set serveroutput on

define StartYear = "&1"
define EndYear = "&2"

prompt Years from &StartYear to &EndYear

declare
  nLOC_ID P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  iCount pls_integer := 0;
begin
--
-- Locations used in ASR spreadsheets
--
  for rSDIV in
   (with Q_ASR_LOCATIONS as
     (select ASR.COU_CODE,
        ASR.STATSYEAR,
        trim(regexp_replace(coalesce(LCOR.CORRECTED_LOCATION_NAME, ASR.NEW_LOCATION_NAME,
                                     ASR.LOCATION_NAME),
                            ':.*$', '')) as LOC_NAME,
        rtrim(trim(regexp_replace(coalesce(LCOR.CORRECTED_LOCATION_NAME, ASR.NEW_LOCATION_NAME,
                                           ASR.LOCATION_NAME) || ':',
                                  '^[^:]*:', '')), ':') as LOC_TYPE_DESCRIPTION
      from
       (select STATSYEAR, COU_CODE_ASYLUM as COU_CODE,
          replace(LOCATION_NAME, chr(10), '') as LOCATION_NAME,
          replace(NEW_LOCATION_NAME, chr(10), '') as NEW_LOCATION_NAME
        from STAGE.S_ASR_T3
        where STATSYEAR between nvl('&StartYear', '0000') and nvl('&EndYear', '9999')
        union
        select STATSYEAR, COU_CODE_ORIGIN as COU_CODE,
          replace(LOCATION_NAME, chr(10), '') as LOCATION_NAME,
          null as NEW_LOCATION_NAME
        from STAGE.S_ASR_T6
        where STATSYEAR between nvl('&StartYear', '0000') and nvl('&EndYear', '9999')) ASR
      left outer join STAGE.S_LOCATION_NAME_CORRECTIONS LCOR
        on LCOR.COU_CODE_ASYLUM = ASR.COU_CODE
        and LCOR.LOCATION_NAME = ASR.LOCATION_NAME
        and (LCOR.NEW_LOCATION_NAME = ASR.NEW_LOCATION_NAME
          or (LCOR.NEW_LOCATION_NAME is null
            and ASR.NEW_LOCATION_NAME is null))),
  --
    Q_MSRP_LOCATIONS as
     (select COU.UNHCR_COUNTRY_CODE as COU_CODE,
        COU.START_DATE, COU.END_DATE,
        AMS.SITE_CODE as MSRP_CODE,
        AMS.SITE_NAME as LOCATION_NAME
      from STAGE.S_ACTIVE_MSRP_SITES AMS
      inner join COUNTRIES COU
        on COU.ISO3166_ALPHA3_CODE = substr(AMS.SITE_CODE, 1, 3)
      where upper(AMS.SITE_NAME) != 'VARIOUS')
  --
    select distinct ASL.COU_CODE,
      COU.ID as COU_ID,
      COU.START_DATE,
      COU.END_DATE,
      case when upper(ASL.LOC_NAME) = 'VARIOUS' then COU.NAME else ASL.LOC_NAME end as LOC_NAME,
      MSL.MSRP_CODE,
      nvl(max(LOCTV.LOCT_CODE), 'POINT') as LOCT_CODE,
      max(LOCTV.ID) as LOCTV_ID,
      count(distinct LOCTV.ID) LOCTV_COUNT
    from Q_ASR_LOCATIONS ASL
    inner join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = ASL.COU_CODE
      and COU.START_DATE < add_months(to_date(ASL.STATSYEAR || '0101', 'YYYYMMDD'), 12)
      and COU.END_DATE >= add_months(to_date(ASL.STATSYEAR || '0101', 'YYYYMMDD'), 12)
    left outer join LOCATION_TYPE_VARIANTS LOCTV
      on LOCTV.LOC_ID = COU.ID
      and LOCTV.LOCRT_CODE = 'WITHIN'
      and LOCTV.DESCRIPTION =
        case
          when upper(ASL.LOC_NAME) = 'VARIOUS' then 'Dispersed in the country / territory'
          else ASL.LOC_TYPE_DESCRIPTION
        end
    left outer join Q_MSRP_LOCATIONS MSL
      on MSL.COU_CODE = ASL.COU_CODE
      and MSL.START_DATE < add_months(to_date(ASL.STATSYEAR || '0101', 'YYYYMMDD'), 12)
      and MSL.END_DATE >= add_months(to_date(ASL.STATSYEAR || '0101', 'YYYYMMDD'), 12)
      and upper(MSL.LOCATION_NAME) = upper(ASL.LOC_NAME)
    group by ASL.COU_CODE,
      COU.ID,
      COU.START_DATE,
      COU.END_DATE,
      case when upper(ASL.LOC_NAME) = 'VARIOUS' then COU.NAME else ASL.LOC_NAME end,
      MSL.MSRP_CODE)
  loop
    if rSDIV.LOCTV_COUNT > 1
    then dbms_output.put_line('Duplicate location: ' || rSDIV.COU_CODE || '|' || rSDIV.LOC_NAME);
    else
      iCount := iCount + 1;
    --
      P_LOCATION.INSERT_LOCATION
       (nLOC_ID, 'en', rSDIV.LOC_NAME, nvl(rSDIV.LOCT_CODE, 'POINT'),
        pdSTART_DATE => rSDIV.START_DATE, pdEND_DATE => rSDIV.END_DATE);
    --
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP
       (rSDIV.COU_ID, nLOC_ID, 'WITHIN',
        pdSTART_DATE => rSDIV.START_DATE, pdEND_DATE => rSDIV.END_DATE);
    --
      if rSDIV.MSRP_CODE is not null
      then
        nVERSION_NBR := 1;
        P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'MSRPLOC', psCHAR_VALUE => rSDIV.MSRP_CODE);
      end if;
    --
      if rSDIV.LOCTV_ID is not null
      then
        nVERSION_NBR := 1;
        P_LOCATION.UPDATE_LOCATION(nLOC_ID, nVERSION_NBR, pnLOCTV_ID => rSDIV.LOCTV_ID);
      end if;
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' LOCATIONS records inserted');
--
-- Locations defined but not used in ASR spreadsheets
--
  iCount := 0;
--
  for rSDIV in
   (select ALOC.UNHCR_COUNTRY_CODE, ALOC.COUNTRY_NAME,
      ALOC.LOCATION_NAME, ALOC.LOCATION_TYPE_DESCRIPTION, ALOC.LOCATION_TYPE_CODE,
      COU.ID as COU_ID, LOCTV.ID as LOCTV_ID
    from STAGE.S_ASR_ADDITIONAL_LOCATIONS ALOC
    inner join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = ALOC.UNHCR_COUNTRY_CODE
    left outer join LOCATION_TYPE_VARIANTS LOCTV
      on LOCTV.LOC_ID = COU.ID
      and LOCTV.LOCRT_CODE = 'WITHIN'
      and LOCTV.DESCRIPTION = ALOC.LOCATION_TYPE_DESCRIPTION
    order by ALOC.UNHCR_COUNTRY_CODE, ALOC.LOCATION_NAME, ALOC.LOCATION_TYPE_DESCRIPTION)
  loop
    iCount := iCount + 1;
  --
    P_LOCATION.INSERT_LOCATION(nLOC_ID, 'en', rSDIV.LOCATION_NAME, rSDIV.LOCATION_TYPE_CODE);
  --
    P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rSDIV.COU_ID, nLOC_ID, 'WITHIN');
  --
    if rSDIV.LOCTV_ID is not null
    then
      nVERSION_NBR := 1;
      P_LOCATION.UPDATE_LOCATION(nLOC_ID, nVERSION_NBR, pnLOCTV_ID => rSDIV.LOCTV_ID);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' LOCATIONS records inserted');
--
-- Merge duplicate locations in countries that have split, merged, or changed their details
--
  for rLOCR in
   (select LOCR1.LOC_ID_FROM as LOC_ID_FROM1, LOCR1.LOC_ID_TO as LOC_ID_TO1,
      LOCR1.VERSION_NBR as LOCR_VERSION_NBR, LOC1.VERSION_NBR as LOC_VERSION_NBR1,
      LOCR2.LOC_ID_FROM as LOC_ID_FROM2, LOCR2.LOC_ID_TO as LOC_ID_TO2,
      LOCR2.START_DATE, LOCR2.END_DATE, LOC2.VERSION_NBR as LOC_VERSION_NBR2,
      LOCR1.LOCRT_CODE, LOCR.LOCRT_CODE as LOCRT_CODE1, LOC1.NAME
    from T_LOCATION_RELATIONSHIPS LOCR
    inner join T_LOCATION_RELATIONSHIPS LOCR1
      on LOCR1.LOC_ID_FROM = LOCR.LOC_ID_FROM
      and LOCR1.LOCRT_CODE not in ('CSPLIT', 'CMERGE', 'CCHANGE')
    inner join LOCATIONS LOC1
      on LOC1.ID = LOCR1.LOC_ID_TO
    inner join T_LOCATION_RELATIONSHIPS LOCR2
      on LOCR2.LOC_ID_FROM = LOCR.LOC_ID_TO
      and LOCR2.LOCRT_CODE not in ('CSPLIT', 'CMERGE', 'CCHANGE')
    inner join LOCATIONS LOC2
      on LOC2.ID = LOCR2.LOC_ID_TO
    where LOCR.LOCRT_CODE in ('CSPLIT', 'CMERGE', 'CCHANGE')
    and LOCR2.LOCRT_CODE = LOCR1.LOCRT_CODE
    and LOC2.LOCT_CODE != 'ADMIN0'
    and LOC2.NAME = LOC1.NAME)
  loop
    P_LOCATION.UPDATE_LOCATION
     (rLOCR.LOC_ID_TO1, rLOCR.LOC_VERSION_NBR1, pdEND_DATE => rLOCR.END_DATE);
  --
    P_LOCATION.INSERT_LOCATION_RELATIONSHIP
     (rLOCR.LOC_ID_FROM2, rLOCR.LOC_ID_TO1, rLOCR.LOCRT_CODE, rLOCR.START_DATE, rLOCR.END_DATE);
  --
    P_LOCATION.DELETE_LOCATION(rLOCR.LOC_ID_TO2, rLOCR.LOC_VERSION_NBR2);
  end loop;
end;
/
