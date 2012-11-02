set serveroutput on

declare
  nLOC_ID P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  iCount pls_integer := 0;
begin
  for rSDIV in
   (with Q_ASR_LOCATIONS as
     (select ASR.COU_CODE,
        ASR.STATSYEAR,
        nvl2(LCOR.CORRECTED_LOCATION_NAME,
             trim(regexp_replace(LCOR.CORRECTED_LOCATION_NAME, ':.*$', '')),
             nvl2(ASR.NEW_LOCATION_NAME,
                  trim(regexp_replace(ASR.NEW_LOCATION_NAME, ':.*$', '')),
                  trim(regexp_replace(ASR.LOCATION_NAME, ':.*$', '')))) as LOC_NAME,
        rtrim(nvl2(LCOR.CORRECTED_LOCATION_NAME,
                   trim(regexp_replace(LCOR.CORRECTED_LOCATION_NAME || ':', '^[^:]*:', '')),
                   nvl2(ASR.NEW_LOCATION_NAME,
                        trim(regexp_replace(ASR.NEW_LOCATION_NAME || ':', '^[^:]*:', '')),
                        trim(regexp_replace(ASR.LOCATION_NAME || ':', '^[^:]*:', '')))),
              ':') as LOC_TYPE_DESCRIPTION
      from
       (select STATSYEAR, COU_CODE_ASYLUM as COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME
        from STAGE.S_ASR_T3
        union
        select STATSYEAR, COU_CODE_ORIGIN as COU_CODE, LOCATION_NAME, null as NEW_LOCATION_NAME
        from STAGE.S_ASR_T6) ASR
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
      ASL.LOC_NAME,
      MSL.MSRP_CODE,
      nvl(max(LOCTV.LOCT_CODE), 'POINT') as LOCT_CODE,
      max(LOCTV.ID) as LOCTV_ID,
      count(distinct LOCTV.ID) LOCTV_COUNT
    from Q_ASR_LOCATIONS ASL
    join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = ASL.COU_CODE
      and COU.START_DATE <= add_months(trunc(to_date(ASL.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and COU.END_DATE > add_months(trunc(to_date(ASL.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
    left outer join LOCATION_TYPE_VARIANTS LOCTV
      on LOCTV.LOC_ID = COU.ID
      and LOCTV.LOCRT_CODE = 'WITHIN'
      and LOCTV.DESCRIPTION = ASL.LOC_TYPE_DESCRIPTION
    left outer join Q_MSRP_LOCATIONS MSL
      on MSL.COU_CODE = ASL.COU_CODE
      and MSL.START_DATE <= add_months(trunc(to_date(ASL.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and MSL.END_DATE > add_months(trunc(to_date(ASL.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and upper(MSL.LOCATION_NAME) = upper(ASL.LOC_NAME)
    group by ASL.COU_CODE,
      COU.ID,
      COU.START_DATE,
      COU.END_DATE,
      ASL.LOC_NAME,
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
end;
/
