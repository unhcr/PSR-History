set serveroutput on

declare
  nID P_BASE.tnSTC_ID;
  nCount pls_integer := 0;
begin
  for rDEM in
   (select
      case DEM.BASIS
        when 'C' then 'POCPOPC'
        when 'E' then 'POCPOPE'
        when 'R' then 'POCPOPR'
        when 'RE' then 'POCPOPRE'
        when 'RS' then 'POCPOPRS'
        when 'S' then 'POCPOPS'
        else 'POCPOPO'
      end STCT_CODE,
      HLOC.ID LOC_ID_ASYLUM,
      COU.ID LOC_ID_COUNTRY,
      LOC.ID LOC_ID_ORIGIN,
      upper(DEM.DST_CODE) DST_CODE,
      PER.ID PER_ID,
      DEM.SEX_CODE,
      AGR.ID AGR_ID,
      DIM1.ID DIM_ID1,
      DIM2.ID DIM_ID2,
      DEM.VALUE
    from
     (select COUNTRY_CODE, LOC_NAME, RCX_CODE, ACMT_DESCRIPTION, DST_CODE, COUNTRY_CODE_ORIGIN, BASIS,
        substr(SEX_AGE, 1, 1) SEX_CODE, to_number(substr(SEX_AGE, 2)) AGE_FROM, VALUE
      from
       (select COUNTRY_CODE, LOC_NAME, RCX_CODE, ACMT_DESCRIPTION, DST_CODE, COUNTRY_CODE_ORIGIN, BASIS,
          sum(F0_4) F0_4, sum(F5_11) F5_11, sum(F12_17) F12_17, sum(F18_59) F18_59, sum(F60) F60, sum(FTOTAL) FTOTAL,
          sum(M0_4) M0_4, sum(M5_11) M5_11, sum(M12_17) M12_17, sum(M18_59) M18_59, sum(M60) M60, sum(MTOTAL) MTOTAL,
          sum(TOTAL) TOTAL
        from
         (select COUNTRY_CODE, regexp_replace(nvl(LOC_NAME, LOC_NAME_NEW), ' : .*$', '') LOC_NAME,
            RCX_CODE, ACMT_DESCRIPTION, DST_CODE, upper(COUNTRY_CODE_ORIGIN) COUNTRY_CODE_ORIGIN, BASIS,
            F0_4, F5_11, F12_17, F18_59, F60,
            case when F0_4 is null and F5_11 is null and F12_17 is null and F18_59 is null and F60 is null and FOTHER is null then FTOTAL else FOTHER end FTOTAL,
            M0_4, M5_11, M12_17, M18_59, M60,
            case when M0_4 is null and M5_11 is null and M12_17 is null and M18_59 is null and M60 is null and MOTHER is null then MTOTAL else MOTHER end MTOTAL,
            case when F0_4 is null and F5_11 is null and F12_17 is null and F18_59 is null and F60 is null and FOTHER is null and FTOTAL is null and
              M0_4 is null and M5_11 is null and M12_17 is null and M18_59 is null and M60 is null and MOTHER is null and MTOTAL is null
            then TOTAL end TOTAL
          from STAGE.DEMOGRAPHICS_2010)
        group by COUNTRY_CODE, LOC_NAME, RCX_CODE, ACMT_DESCRIPTION, DST_CODE, COUNTRY_CODE_ORIGIN, BASIS)
      unpivot
       (VALUE for SEX_AGE in (F0_4 as 'F00', F5_11 as 'F05', F12_17 as 'F12', F18_59 as 'F18', F60, FTOTAL as 'F',
                              M0_4 as 'M00', M5_11 as 'M05', M12_17 as 'M12', M18_59 as 'M18', M60, MTOTAL as 'M', TOTAL as ''))) DEM
    join COUNTRIES COU
    on COU.UNHCR_COUNTRY_CODE = DEM.COUNTRY_CODE
    join HIERARCHICAL_LOCATIONS HLOC
    on HLOC.LOC_ID_FROM = COU.ID
    and nlssort(HLOC.NAME, 'NLS_SORT=BINARY_AI') = nlssort(DEM.LOC_NAME, 'NLS_SORT=BINARY_AI')
    left outer join T_LOCATION_ATTRIBUTES LOCA
    on LOCA.CHAR_VALUE = DEM.COUNTRY_CODE_ORIGIN
    and LOCA.LOCAT_CODE = 'UNHCRCC'
    left outer join LOCATIONS LOC
    on LOC.ID = LOCA.LOC_ID
    and LOC.LOCT_CODE in ('COUNTRY', 'OTHORIGIN')
    cross join
     (select ID
      from T_TIME_PERIODS
      where PERT_CODE = 'YEAR'
      and START_DATE = date '2010-01-01'
      and END_DATE = date '2011-01-01') PER
    left outer join T_AGE_RANGES AGR
    on AGR.AGP_CODE = 'STD'
    and AGR.AGE_FROM = DEM.AGE_FROM
    join T_DIMENSION_VALUES DIM1
    on DIM1.CODE = DEM.RCX_CODE
    and DIM1.DIMT_CODE = 'UR'
    join DIMENSION_VALUES DIM2
    on DIM2.DESCRIPTION = DEM.ACMT_DESCRIPTION
    and DIM2.DIMT_CODE = 'ACMT')
  loop
    P_STATISTIC.INSERT_STATISTIC
     (nID,
      psSTCT_CODE => rDEM.STCT_CODE,
      pnLOC_ID_COUNTRY => rDEM.LOC_ID_COUNTRY,
      pnLOC_ID_ASYLUM => rDEM.LOC_ID_ASYLUM,
      pnLOC_ID_ORIGIN => rDEM.LOC_ID_ORIGIN,
      psDST_CODE => rDEM.DST_CODE,
      pnPER_ID => rDEM.PER_ID,
      psSEX_CODE => rDEM.SEX_CODE,
      pnAGR_ID => rDEM.AGR_ID,
      pnDIM_ID1 => rDEM.DIM_ID1,
      pnDIM_ID2 => rDEM.DIM_ID2,
      pnVALUE => rDEM.VALUE);
    nCount := nCount + 1;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' statistic records inserted');
end;
/
