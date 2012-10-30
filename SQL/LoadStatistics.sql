set serveroutput on size 1000000

declare
  nPGR_ID P_BASE.tnPGR_ID;
  nSTC_ID P_BASE.tnSTC_ID;
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  for rSTC in
   (with
    UNPIVOTED_STATISTICS as
     (--
      -- Table II
      --
      select TABLE_NUMBER,
        STATSYEAR,
        decode(nvl(upper(DISPLACEMENT_STATUS), 'REF'),
               'REF', 'REF', 'REF-LIKE', 'ROC', 'XXX') as DST_CODE,
        upper(COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
        null as LOCATION_NAME,
        upper(COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
        null as DIMT_CODE1,
        null as DIM_CODE1,
        null as DIMT_CODE2,
        null as DIM_CODE2,
        null as SUBGROUP_NAME,
        null as PPG_NAME,
        SOURCE,
        BASIS,
        substr(COLUMN_CODE, 1, 1) as PERIOD_FLAG,
        substr(COLUMN_CODE, 3) as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from STAGE.S_ASR_T2
      unpivot
       (VALUE for COLUMN_CODE in
         (POP_START as 'S/REFPOP',
          POP_AH_START as 'S/REFPOP-AH',
          ARR_GRP as 'F/ARR-GRP',
          ARR_IND as 'F/ARR-IND',
          ARR_RESTL as 'F/ARR-RESTL',
          BIRTH as 'F/BIRTH',
          REFOTHINC as 'F/REFOTHINC',
          VOLREP as 'F/VOLREP',
          VOLREP_AH as 'F/VOLREP-AH',
          RESTL as 'F/RESTL',
          RESTL_AH as 'F/RESTL-AH',
          CESSATION as 'F/CESSATION',
          NATURLZN as 'F/NATURLZN',
          DEATH as 'F/DEATH',
          REFOTHDEC as 'F/REFOTHDEC',
          POP_END as 'E/REFPOP',
          POP_AH_END as 'E/REFPOP-AH'))
      union all
      --
      -- Table III
      --
      select TABLE_NUMBER,
        STATSYEAR,
        upper(DISPLACEMENT_STATUS) as DST_CODE,
        COU_CODE_ASYLUM,
        LOCATION_NAME,
        COU_CODE_ORIGIN,
        'UR' as DIMT_CODE1,
        URBAN_RURAL_STATUS as DIM_CODE1,
        'ACMT' as DIMT_CODE2,
        case ACCOMMODATION_TYPE
          when 'Camp' then 'CAMP'
          when 'Center' then 'CENTRE'
          when 'Dispersed' then 'DISPERSED'
          when 'Individual accommodation' then 'INDIVIDUAL'
          when 'Settlement' then 'SETTLEMENT'
          when 'Undefined' then 'UNDEFINED'
        end as DIM_CODE2,
        null as SUBGROUP_NAME,
        PPG_NAME,
        null as SOURCE,
        BASIS,
        'E' as PERIOD_FLAG,
        case
          when length(COLUMN_CODE) > 1 then 'POCPOPAS'
          when length(COLUMN_CODE) = 1 then 'POCPOPS'
          else 'POCPOPN'
        end as STCT_CODE,
        substr(COLUMN_CODE, 1, 1) as SEX_CODE,
        to_number(substr(COLUMN_CODE, 2)) as AGE_FROM,
        VALUE
      from
       (select ASR.TABLE_NUMBER, ASR.STATSYEAR,
          ASR.DISPLACEMENT_STATUS,
          upper(ASR.COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
          coalesce(LCOR.CORRECTED_LOCATION_NAME,
                   ASR.NEW_LOCATION_NAME, ASR.LOCATION_NAME) as LOCATION_NAME,
          upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
          ASR.URBAN_RURAL_STATUS, ASR.ACCOMMODATION_TYPE,
          nvl(PCOR.CORRECTED_PPG_NAME, ASR.PPG_NAME) as PPG_NAME,
          ASR.F0_4, ASR.F5_11, ASR.F12_17, ASR.F18_59, ASR.F60,
          case
            when nvl(ASR.F0_4, 0) + nvl(ASR.F5_11, 0) + nvl(ASR.F12_17, 0) + nvl(ASR.F18_59, 0) +
              nvl(ASR.F60, 0) + nvl(ASR.FOTHER, 0) = 0
            then ASR.FTOTAL
            else ASR.FOTHER
          end as FOTHER,
          ASR.M0_4, ASR.M5_11, ASR.M12_17, ASR.M18_59, ASR.M60,
          case
            when nvl(ASR.M0_4, 0) + nvl(ASR.M5_11, 0) + nvl(ASR.M12_17, 0) + nvl(ASR.M18_59, 0) +
              nvl(ASR.M60, 0) + nvl(ASR.MOTHER, 0) = 0
            then ASR.MTOTAL
            else ASR.MOTHER
          end as MOTHER,
          case
            when nvl(ASR.F0_4, 0) + nvl(ASR.F5_11, 0) + nvl(ASR.F12_17, 0) + nvl(ASR.F18_59, 0) +
              nvl(ASR.F60, 0) + nvl(ASR.FOTHER, 0) + nvl(ASR.FTOTAL, 0) +
              nvl(ASR.M0_4, 0) + nvl(ASR.M5_11, 0) + nvl(ASR.M12_17, 0) + nvl(ASR.M18_59, 0) +
              nvl(ASR.M60, 0) + nvl(ASR.MOTHER, 0) + nvl(ASR.MTOTAL, 0) = 0
            then ASR.TOTAL
          end as TOTAL,
          ASR.BASIS
        from STAGE.S_ASR_T3 ASR
        left outer join STAGE.S_LOCATION_NAME_CORRECTIONS LCOR
          on LCOR.COU_CODE_ASYLUM = upper(ASR.COU_CODE_ASYLUM)
          and LCOR.LOCATION_NAME = ASR.LOCATION_NAME
          and (LCOR.NEW_LOCATION_NAME = ASR.NEW_LOCATION_NAME
            or (LCOR.NEW_LOCATION_NAME is null
              and ASR.NEW_LOCATION_NAME is null))
        left outer join STAGE.S_PPG_CORRECTIONS PCOR
          on PCOR.STATSYEAR = ASR.STATSYEAR
          and PCOR.COU_CODE_ASYLUM = upper(ASR.COU_CODE_ASYLUM)
          and PCOR.PPG_NAME = ASR.PPG_NAME)
      unpivot
       (VALUE for COLUMN_CODE in
         (F0_4 as 'F00',
          F5_11 as 'F05',
          F12_17 as 'F12',
          F18_59 as 'F18',
          F60 as 'F60',
          FOTHER as 'F',
          M0_4 as 'M00',
          M5_11 as 'M05',
          M12_17 as 'M12',
          M18_59 as 'M18',
          M60 as 'M60',
          MOTHER as 'M',
          TOTAL as ''))
      union all
      --
      -- Table IV
      --
      select TABLE_NUMBER, STATSYEAR,
        decode(nvl(upper(DISPLACEMENT_STATUS), 'REF'), 'REF', 'REF', 'REF-LIKE', 'ROC', 'XXX') as DST_CODE,
        upper(COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
        null as LOCATION_NAME,
        upper(COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
        'LGLBASIS' as DIMT_CODE1,
        LEGAL_BASIS as DIM_CODE1,
        null as DIMT_CODE2,
        null as DIM_CODE2,
        null as SUBGROUP_NAME,
        null as PPG_NAME,
        null as SOURCE,
        null as BASIS,
        'E' as PERIOD_FLAG,
        'REFPOP-LB' as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from STAGE.S_ASR_T4
      unpivot
       (VALUE for LEGAL_BASIS in
         (UNCONV51 as 'UNCONV51',
          OAUCONV69 as 'OAUCONV69',
          HCRSTAT as 'HCRSTAT',
          COMPPROT as 'COMPPROT',
          TEMPPROT as 'TEMPPROT',
          OTHER as 'OTHER',
          UNKNOWN as 'UNKNOWN'))
      union all
      --
      -- Table V
      --
      select TABLE_NUMBER, STATSYEAR, DST_CODE,
        upper(COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
        null as LOCATION_NAME,
        upper(COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
        'RSDTYPE' as DIMT_CODE1,
        DIM_RSDTYPE_VALUE as DIM_CODE1,
        'RSDLEVEL' as DIMT_CODE2,
        DIM_RSDLEVEL_VALUE as DIM_CODE2,
        null as SUBGROUP_NAME,
        null as PPG_NAME,
        null as SOURCE,
        null as BASIS,
        substr(COLUMN_CODE, 1, 1) as PERIOD_FLAG,
        substr(COLUMN_CODE, 3) as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from STAGE.S_ASR_T5
      unpivot
       (VALUE for COLUMN_CODE in
         (ASY_START as 'S/ASYPOP',
          ASY_AH_START as 'S/ASYPOP-AH',
          ASYAPP as 'F/ASYAPP',
          ASYREC_CV as 'F/ASYREC-CV',
          ASYREC_CP as 'F/ASYREC-CP',
          ASYREJ as 'F/ASYREJ',
          ASYOTHCL as 'F/ASYOTHCL',
          ASY_END as 'E/ASYPOP',
          ASY_AH_END as 'E/ASYPOP-AH'))
      union all
      --
      -- Table VI.A and VI.B
      --
      select TABLE_NUMBER, STATSYEAR, DST_CODE,
        COU_CODE_ORIGIN as COU_CODE_ASYLUM,
        LOCATION_NAME,
        COU_CODE_ORIGIN,
        case
          when TABLE_NUMBER in ('6A', '6B') and OFFICIAL is not null
          then 'OFFICIAL'
        end as DIMT_CODE1,
        case
          when TABLE_NUMBER in ('6A', '6B')
          then decode(OFFICIAL, 'yes', 'Y', 'no', 'N')
        end as DIM_CODE1,
        null as DIMT_CODE2,
        null as DIM_CODE2,
        null as SUBGROUP_NAME,
        null as PPG_NAME,
        SOURCE,
        BASIS,
        substr(COLUMN_CODE, 1, 1) as PERIOD_FLAG,
        case TABLE_NUMBER
          when '6A' then 'IDPH'
          when '6B' then 'IDPH'
          when '6C' then 'IDPC'
          when '6D' then 'IDPD'
        end || substr(COLUMN_CODE, 3) as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from
       (select ASR.TABLE_NUMBER, ASR.STATSYEAR,
          ASR.OFFICIAL, ASR.DST_CODE,
          upper(ASR.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
          coalesce(LCOR.CORRECTED_LOCATION_NAME, ASR.LOCATION_NAME) as LOCATION_NAME,
          ASR.POP_START, ASR.POP_AH_START,
          ASR.IDPNEW, ASR.IDPOTHINC,
          ASR.RETURN, ASR.RETURN_AH, ASR.IDPRELOC, ASR.IDPOTHDEC,
          ASR.POP_END, ASR.POP_AH_END,
          ASR.SOURCE, ASR.BASIS
        from STAGE.S_ASR_T6 ASR
        left outer join STAGE.S_LOCATION_NAME_CORRECTIONS LCOR
          on LCOR.COU_CODE_ASYLUM = upper(ASR.COU_CODE_ORIGIN)
          and LCOR.LOCATION_NAME = ASR.LOCATION_NAME)
      unpivot
       (VALUE for COLUMN_CODE in
         (POP_START as 'S/POP',
          POP_AH_START as 'S/POP-AH',
          IDPNEW as 'F/NEW',
          IDPOTHINC as 'F/OTHINC',
          RETURN as 'F/RTN',
          RETURN_AH as 'F/RTN-AH',
          IDPRELOC as 'F/RELOC',
          IDPOTHDEC as 'F/OTHDEC',
          POP_END as 'E/POP',
          POP_AH_END as 'E/POP-AH'))
      union all
      --
      -- Table VII.A and VII.B
      --
      select TABLE_NUMBER, STATSYEAR, DST_CODE,
        upper(COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
        null as LOCATION_NAME,
        upper(COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
        null as DIMT_CODE1,
        null as DIM_CODE1,
        null as DIMT_CODE2,
        null as DIM_CODE2,
        null as SUBGROUP_NAME,
        null as PPG_NAME,
        SOURCE,
        BASIS,
        substr(COLUMN_CODE, 1, 1) as PERIOD_FLAG,
        substr(COLUMN_CODE, 3) as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from STAGE.S_ASR_T7AB
      unpivot
       (VALUE for COLUMN_CODE in
         (RETURN as 'F/REFRTN',
          RETURN_AH as 'F/REFRTN-AH'))
      union all
      --
      -- Table VII.C
      --
      select TABLE_NUMBER, STATSYEAR, DST_CODE,
        upper(COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
        null as LOCATION_NAME,
        upper(COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
        null as DIMT_CODE1,
        null as DIM_CODE1,
        null as DIMT_CODE2,
        null as DIM_CODE2,
        DESCRIPTION as SUBGROUP_NAME,
        null as PPG_NAME,
        SOURCE,
        BASIS,
        substr(COLUMN_CODE, 1, 1) as PERIOD_FLAG,
        substr(COLUMN_CODE, 3) as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from STAGE.S_ASR_T7C
      unpivot
       (VALUE for COLUMN_CODE in
         (POP_START as 'S/STAPOP',
          POP_AH_START as 'S/STAPOP-AH',
          NATLOSS as 'F/NATLOSS',
          STAOTHINC as 'F/STAOTHINC',
          NATACQ as 'F/NATACQ',
          STAOTHDEC as 'F/STAOTHDEC',
          POP_END as 'E/STAPOP',
          POP_AH_END as 'E/STAPOP-AH'))
      union all
      --
      -- Table VII.D
      --
      select TABLE_NUMBER, STATSYEAR, DST_CODE,
        upper(COU_CODE_ASYLUM) as COU_CODE_ASYLUM,
        null as LOCATION_NAME,
        upper(COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
        null as DIMT_CODE1,
        null as DIM_CODE1,
        null as DIMT_CODE2,
        null as DIM_CODE2,
        DESCRIPTION as SUBGROUP_NAME,
        null as PPG_NAME,
        SOURCE,
        BASIS,
        substr(COLUMN_CODE, 1, 1) as PERIOD_FLAG,
        substr(COLUMN_CODE, 3) as STCT_CODE,
        null as SEX_CODE,
        to_number(null) as AGE_FROM,
        VALUE
      from STAGE.S_ASR_T7D
      unpivot
       (VALUE for COLUMN_CODE in
         (POP_START as 'S/OOCPOP',
          POP_AH_START as 'S/OOCPOP-AH',
          OOCARR as 'F/OOCARR',
          OOCOTHINC as 'F/OOCOTHINC',
          OOCRTN as 'F/OOCRTN',
          OOCOTHDEC as 'F/OOCOTHDEC',
          POP_END as 'E/OOCPOP',
          POP_AH_END as 'E/OOCPOP-AH'))),
  --
    AGGREGATED_STATISTICS as
     (select TABLE_NUMBER, STATSYEAR,
        trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY') as START_DATE_YEAR,
        add_months(trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY'), 12) as END_DATE_YEAR,
        case PERIOD_FLAG
          when 'S' then trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY')
          when 'E' then add_months(trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
          when 'F' then trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY')
        end as START_DATE,
        case PERIOD_FLAG
          when 'S' then trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY') + 1
          when 'E' then add_months(trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY'), 12)
          when 'F' then add_months(trunc(to_date(STATSYEAR, 'YYYY'), 'YYYY'), 12)
        end as END_DATE,
        DST_CODE, COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
        DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME,
        PPG_NAME, PPG_COUNT, SOURCE, BASIS,
        PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM,
        sum(VALUE) as VALUE
      from
       (select TABLE_NUMBER, STATSYEAR, DST_CODE,
          COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
          DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME, PPG_NAME,
          count(distinct nvl(PPG_NAME, 'zzz')) over
           (partition by TABLE_NUMBER, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME) as PPG_COUNT,
          STAGE.CHARAGG(SOURCE) over
           (partition by TABLE_NUMBER, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME, PPG_NAME) as SOURCE,
          STAGE.CHARAGG(BASIS) over
           (partition by TABLE_NUMBER, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME, PPG_NAME) as BASIS,
          PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM,
          VALUE
        from
         (select TABLE_NUMBER, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME,
            decode(COU_CODE_ORIGIN, 'YUG', 'SRB', COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME, PPG_NAME,
            SOURCE, BASIS,
            PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM,
            VALUE
          from UNPIVOTED_STATISTICS
          where VALUE != 0))
      group by TABLE_NUMBER, STATSYEAR, DST_CODE,
        COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
        DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, SUBGROUP_NAME,
        PPG_NAME, PPG_COUNT, SOURCE, BASIS,
        PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM)
  --
    select STC.TABLE_NUMBER,
      STC.STATSYEAR,
      STC.START_DATE_YEAR,
      STC.END_DATE_YEAR,
      STC.START_DATE,
      STC.END_DATE,
      STC.DST_CODE,
      STC.COU_CODE_ASYLUM,
      STC.LOCATION_NAME,
      STC.COU_CODE_ORIGIN,
      STC.DIMT_CODE1,
      STC.DIM_CODE1,
      STC.DIMT_CODE2,
      STC.DIM_CODE2,
      nvl(STC.SUBGROUP_NAME, case when STC.PPG_COUNT > 1 then STC.PPG_NAME end) as SUBGROUP_NAME,
      STC.PPG_NAME,
      STC.PPG_COUNT,
      nvl(PPG1.PPG_ID, PPG2.PPG_ID) as PPG_ID,
      STC.SOURCE,
      STC.BASIS,
      STC.PERIOD_FLAG,
      STC.STCT_CODE,
      STC.SEX_CODE,
      STC.AGE_FROM,
      STC.VALUE,
      nvl(COU.ID, case when STC.COU_CODE_ASYLUM != 'VAR' then -1 end) as LOC_ID_ASYLUM_COUNTRY,
      LOC.LOC_ID as LOC_ID_ASYLUM,
      nvl(OGN.ID, case when STC.COU_CODE_ORIGIN != 'VAR' then -1 end) as LOC_ID_ORIGIN_COUNTRY,
      DIM1.ID as DIM_ID1,
      DIM2.ID as DIM_ID2,
      AGR.ID as AGR_ID,
      row_number() over
       (partition by STC.STATSYEAR, STC.DST_CODE, COU.ID, LOC.LOC_ID, OGN.ID, DIM1.ID, DIM2.ID,
          nvl(STC.SUBGROUP_NAME, case when STC.PPG_COUNT > 1 then STC.PPG_NAME end),
          nvl(PPG1.PPG_ID, PPG2.PPG_ID)
        order by STC.PERIOD_FLAG, STC.STCT_CODE, STC.SEX_CODE, AGR.ID) as PSG_CHILD_NUMBER
    from AGGREGATED_STATISTICS STC
    left outer join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and COU.START_DATE <= add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and COU.END_DATE > add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
    left outer join
     (select LOCR.LOC_ID_FROM, LOCR.LOCRT_CODE, LOCR.START_DATE, LOCR.END_DATE,
        LOC.ID LOC_ID, LOC.NAME
      from LOCATION_RELATIONSHIPS LOCR
      join LOCATIONS LOC
        on LOC.ID = LOCR.LOC_ID_TO) LOC
      on LOC.LOC_ID_FROM = COU.ID
      and LOC.LOCRT_CODE = 'WITHIN'
      and LOC.START_DATE <= add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and LOC.END_DATE > add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and LOC.NAME = trim(regexp_replace(STC.LOCATION_NAME, ':.*$', ''))
    left outer join ORIGINS OGN
      on OGN.UNHCR_COUNTRY_CODE = STC.COU_CODE_ORIGIN
      and OGN.START_DATE <= add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and OGN.END_DATE > add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
    left outer join DIMENSION_VALUES DIM1
      on DIM1.DIMT_CODE = STC.DIMT_CODE1
      and DIM1.CODE = STC.DIM_CODE1
    left outer join DIMENSION_VALUES DIM2
      on DIM2.DIMT_CODE = STC.DIMT_CODE2
      and DIM2.CODE = STC.DIM_CODE2
    left outer join
     (select COU.UNHCR_COUNTRY_CODE, PPG.ID as PPG_ID, PPG.DESCRIPTION as PPG_NAME,
        greatest(COU.START_DATE, PPG.START_DATE) as START_DATE,
        least(COU.END_DATE, PPG.END_DATE) as END_DATE
      from COUNTRIES COU
      inner join POPULATION_PLANNING_GROUPS PPG
        on PPG.LOC_ID = COU.ID) PPG1
      on PPG1.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and PPG1.PPG_NAME = STC.PPG_NAME
      and PPG1.START_DATE <= trunc(to_date(STC.STATSYEAR || '-12-31', 'YYYY-MM-DD'))
      and PPG1.END_DATE >= trunc(to_date(STC.STATSYEAR || '-12-31', 'YYYY-MM-DD'))
    left outer join
     (select COU.UNHCR_COUNTRY_CODE, PPG.ID as PPG_ID, PPG.DESCRIPTION as PPG_NAME,
        greatest(COU.START_DATE, PPG.START_DATE) as START_DATE,
        least(COU.END_DATE, PPG.END_DATE) as END_DATE
      from COUNTRIES COU
      inner join LOCATION_RELATIONSHIPS LOCR
        on LOCR.LOC_ID_TO = COU.ID
        and LOCR.LOCRT_CODE = 'HCRRESP'
      inner join LOCATIONS LOC
        on LOC.ID = LOCR.LOC_ID_FROM
        and LOC.LOCT_CODE = 'HCR-ROF'
      inner join POPULATION_PLANNING_GROUPS PPG
        on PPG.LOC_ID = LOC.ID) PPG2
      on PPG2.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and PPG2.PPG_NAME = STC.PPG_NAME
      and PPG2.START_DATE <= trunc(to_date(STC.STATSYEAR || '-12-31', 'YYYY-MM-DD'))
      and PPG2.END_DATE >= trunc(to_date(STC.STATSYEAR || '-12-31', 'YYYY-MM-DD'))
    left outer join T_AGE_RANGES AGR
      on AGR.AGP_CODE = 'STD'
      and AGR.AGE_FROM = STC.AGE_FROM
    order by STATSYEAR, DST_CODE, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY,
      DIM_ID1, DIM_ID2, SUBGROUP_NAME, PPG_ID, PERIOD_FLAG, STCT_CODE, SEX_CODE, AGR_ID)
  loop
    PLS_UTILITY.TRACE_POINT
     ('Trace',
      rSTC.TABLE_NUMBER || '~' || rSTC.STATSYEAR || '~' || rSTC.DST_CODE || '~' ||
        rSTC.COU_CODE_ASYLUM || '~' || rSTC.LOCATION_NAME || '~' || rSTC.COU_CODE_ORIGIN || '~' ||
        rSTC.DIMT_CODE1 || '~' || rSTC.DIM_CODE1 || '~' ||
        rSTC.DIMT_CODE2 || '~' || rSTC.DIM_CODE2 || '~' ||
        rSTC.SUBGROUP_NAME || '~' || rSTC.PPG_NAME || '~' || rSTC.STCT_CODE || '~' ||
        rSTC.PERIOD_FLAG || '~' || rSTC.SEX_CODE || '~' || to_char(rSTC.AGE_FROM));
  --
    if rSTC.LOC_ID_ASYLUM_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.TABLE_NUMBER || '~' || rSTC.STATSYEAR || '~' ||
          rSTC.COU_CODE_ASYLUM);
    elsif rSTC.LOC_ID_ORIGIN_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid origin: ' || rSTC.TABLE_NUMBER || '~' || rSTC.STATSYEAR || '~' ||
          rSTC.COU_CODE_ORIGIN);
    else
      if rSTC.PSG_CHILD_NUMBER = 1
      then
        P_POPULATION_GROUP.INSERT_POPULATION_GROUP
         (nPGR_ID, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psDST_CODE => rSTC.DST_CODE,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ASYLUM => rSTC.LOC_ID_ASYLUM,
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
          pnDIM_ID1 => rSTC.DIM_ID1,
          pnDIM_ID2 => rSTC.DIM_ID2,
          psLANG_CODE => case when rSTC.SUBGROUP_NAME is not null then 'en' end,
          psSUBGROUP_NAME => rSTC.SUBGROUP_NAME,
          pnPPG_ID => rSTC.PPG_ID);
        iCount1 := iCount1 + 1;
      --
        if rSTC.SOURCE is not null
        then P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE(nPGR_ID, 'SOURCE', rSTC.SOURCE);
        end if;
      --
        if rSTC.BASIS is not null
        then P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE(nPGR_ID, 'BASIS', rSTC.BASIS);
        end if;
      end if;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, rSTC.STCT_CODE, rSTC.START_DATE, rSTC.END_DATE,
        psDST_CODE => rSTC.DST_CODE,
        pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ASYLUM => rSTC.LOC_ID_ASYLUM,
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        psSEX_CODE => rSTC.SEX_CODE,
        pnAGR_ID => rSTC.AGR_ID,
        pnPGR_ID_PRIMARY => nPGR_ID,
        pnPPG_ID => rSTC.PPG_ID,
        pnVALUE => rSTC.VALUE);
      iCount2 := iCount2 + 1;
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount1) || ' population segment records inserted');
  dbms_output.put_line(to_char(iCount2) || ' statistic records inserted');
end;
/
