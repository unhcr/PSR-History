set serveroutput on size 1000000

declare
  nSTG_ID P_BASE.tnSTG_ID;
  nSTC_ID P_BASE.tnSTC_ID;
--
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  P_UTILITY.START_MODULE('LoadRefugeeStatistics');
--
  for rSTC in
   (select STC.STATSYEAR,
      STC.START_DATE_YEAR,
      STC.END_DATE_YEAR,
      STC.START_DATE,
      STC.END_DATE,
      STC.DST_CODE,
      STC.COU_CODE_ASYLUM,
      STC.COU_CODE_ORIGIN,
      STC.SOURCE,
      STC.BASIS,
      STC.STCT_CODE,
      STC.VALUE,
      DST.ID as DST_ID,
      nvl(COU.ID, -1) as LOC_ID_ASYLUM_COUNTRY,
      case
        when STC.COU_CODE_ORIGIN = 'VAR' then null
        else nvl(OGN.ID, -1)
      end as LOC_ID_ORIGIN_COUNTRY,
      row_number() over
       (partition by STC.STATSYEAR, COU.ID, OGN.ID, DST.ID
        order by STC.START_DATE, STC.STCT_CODE) as STG_CHILD_NUMBER
    from 
     (select STATSYEAR,
        to_date(STATSYEAR || '0101', 'YYYYMMDD') as START_DATE_YEAR,
        add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12) as END_DATE_YEAR,
        case
          when DATA_POINT in ('POP_END', 'POP_AH_END')
          then to_date(STATSYEAR || '1231', 'YYYYMMDD')
          else to_date(STATSYEAR || '0101', 'YYYYMMDD')
        end as START_DATE,
        case
          when DATA_POINT in ('POP_START', 'POP_AH_START')
          then to_date(STATSYEAR || '0102', 'YYYYMMDD')
          else add_months(to_date(STATSYEAR || '0101', 'YYYYMMDD'), 12)
        end as END_DATE,
        DST_CODE, COU_CODE_ASYLUM, COU_CODE_ORIGIN, SOURCE, BASIS,
        case
          when DATA_POINT in ('POP_START', 'POP_END') then 'REFPOP'
          when DATA_POINT in ('POP_AH_START', 'POP_AH_END') then 'REFPOP-AH'
          else replace(DATA_POINT, '_', '-')
        end as STCT_CODE,
        VALUE
      from STAGE.S_ASR_REFUGEES) STC
    left outer join T_DISPLACEMENT_STATUSES DST
      on DST.CODE = STC.DST_CODE
      and DST.START_DATE < STC.END_DATE_YEAR
      and DST.END_DATE >= STC.END_DATE_YEAR
    left outer join
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE = 'COUNTRY'
      where LOCA.LOCAT_CODE = 'HCRCC') COU
      on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and COU.START_DATE < STC.END_DATE_YEAR
      and COU.END_DATE >= STC.END_DATE_YEAR
    left outer join
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, LOC.START_DATE,
        lead(LOC.START_DATE, 1, P_BASE.MAX_DATE) over
         (partition by LOCA.CHAR_VALUE order by LOC.START_DATE) as END_DATE,
        LOC.ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE in ('COUNTRY', 'OTHORIGIN')
      where LOCA.LOCAT_CODE = 'HCRCC') OGN
      on OGN.UNHCR_COUNTRY_CODE = STC.COU_CODE_ORIGIN
      and OGN.START_DATE < STC.END_DATE_YEAR
      and OGN.END_DATE >= STC.END_DATE_YEAR
    order by STATSYEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY, DST_ID,
      START_DATE, STCT_CODE)
  loop
    P_UTILITY.TRACE_POINT
     ('Trace',
      rSTC.STATSYEAR || '~' || rSTC.DST_CODE || '~' ||
        rSTC.COU_CODE_ASYLUM || '~' || rSTC.COU_CODE_ORIGIN || '~' ||
        rSTC.STCT_CODE || '~' || to_char(rSTC.START_DATE, 'YYYY-MM-DD'));
  --
    if rSTC.LOC_ID_ASYLUM_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ASYLUM);
    elsif rSTC.LOC_ID_ORIGIN_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid origin: ' || rSTC.STATSYEAR || '~' || rSTC.COU_CODE_ORIGIN);
    else
      if rSTC.STG_CHILD_NUMBER = 1
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psSTTG_CODE => 'REFUGEE',
          pnDST_ID => rSTC.DST_ID,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY);
        iCount1 := iCount1 + 1;
      --
        if rSTC.SOURCE is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'SOURCE', rSTC.SOURCE);
        end if;
      --
        if rSTC.BASIS is not null
        then P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'BASIS', rSTC.BASIS);
        end if;
      end if;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, rSTC.STCT_CODE, rSTC.START_DATE, rSTC.END_DATE,
        pnDST_ID => rSTC.DST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
        pnSTG_ID_PRIMARY => nSTG_ID,
        pnVALUE => rSTC.VALUE);
      iCount2 := iCount2 + 1;
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount1) || ' statistic group records inserted');
  dbms_output.put_line(to_char(iCount2) || ' statistic records inserted');
--
  P_UTILITY.END_MODULE;
end;
/
