set serveroutput on size 1000000

declare
  nSTG_ID_COUNTRY P_BASE.tnSTG_ID;
  nSTG_ID_TABLE P_BASE.tnSTG_ID;
  nSTG_ID P_BASE.tnSTG_ID;
  nSTC_ID P_BASE.tnSTC_ID;
--
  sSTATSYEAR varchar2(4);
  nLOC_ID_REPORTING_COUNTRY P_BASE.tnLOC_ID;
  sSTTG_CODE P_BASE.tsSTTG_CODE;
--
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
begin
  --P_UTILITY.ENABLE_TRACE('Trace', pbLogFile => true);
  P_UTILITY.START_MODULE('LoadStatistics');
--
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
        case when BASIS in ('C', 'E', 'R', 'S', 'V') then 'REG' end as DIMT_CODE3,
        case
          when BASIS in ('C', 'R') then 'Y'
          when BASIS in ('E', 'S', 'V') then 'N'
        end as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
                   replace(ASR.NEW_LOCATION_NAME, chr(10), ''),
                   replace(ASR.LOCATION_NAME, chr(10), '')) as LOCATION_NAME,
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
          and LCOR.LOCATION_NAME = replace(ASR.LOCATION_NAME, chr(10), '')
          and (LCOR.NEW_LOCATION_NAME = replace(ASR.NEW_LOCATION_NAME, chr(10), '')
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
      -- Table VI
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
          coalesce(LCOR.CORRECTED_LOCATION_NAME, replace(ASR.LOCATION_NAME, chr(10), ''))
            as LOCATION_NAME,
          ASR.POP_START, ASR.POP_AH_START,
          ASR.IDPNEW, ASR.IDPOTHINC,
          ASR.RETURN, ASR.RETURN_AH, ASR.IDPRELOC, ASR.IDPOTHDEC,
          ASR.POP_END, ASR.POP_AH_END,
          ASR.SOURCE, ASR.BASIS
        from STAGE.S_ASR_T6 ASR
        left outer join STAGE.S_LOCATION_NAME_CORRECTIONS LCOR
          on LCOR.COU_CODE_ASYLUM = upper(ASR.COU_CODE_ORIGIN)
          and LCOR.LOCATION_NAME = replace(ASR.LOCATION_NAME, chr(10), ''))
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
        null as DIMT_CODE3,
        null as DIM_CODE3,
        null as DIMT_CODE4,
        null as DIM_CODE4,
        null as DIMT_CODE5,
        null as DIM_CODE5,
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
     (select STATSYEAR, STTG_CODE,
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
        DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, DIMT_CODE3, DIM_CODE3,
        DIMT_CODE4, DIM_CODE4, DIMT_CODE5, DIM_CODE5, SUBGROUP_NAME,
        PPG_NAME, PPG_COUNT, SOURCE, BASIS,
        PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM,
        sum(VALUE) as VALUE
      from
       (select STATSYEAR, STTG_CODE, DST_CODE,
          COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
          DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, DIMT_CODE3, DIM_CODE3,
          DIMT_CODE4, DIM_CODE4, DIMT_CODE5, DIM_CODE5, SUBGROUP_NAME, PPG_NAME,
          count(distinct nvl(PPG_NAME, 'zzz')) over
           (partition by STTG_CODE, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, DIMT_CODE3, DIM_CODE3,
            DIMT_CODE4, DIM_CODE4, DIMT_CODE5, DIM_CODE5, SUBGROUP_NAME) as PPG_COUNT,
          STAGE.CHARAGG(SOURCE) over
           (partition by STTG_CODE, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, DIMT_CODE3, DIM_CODE3,
            DIMT_CODE4, DIM_CODE4, DIMT_CODE5, DIM_CODE5, SUBGROUP_NAME, PPG_NAME) as SOURCE,
          STAGE.CHARAGG(BASIS) over
           (partition by STTG_CODE, STATSYEAR, DST_CODE,
            COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
            DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, DIMT_CODE3, DIM_CODE3,
            DIMT_CODE4, DIM_CODE4, DIMT_CODE5, DIM_CODE5, SUBGROUP_NAME, PPG_NAME) as BASIS,
          PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM,
          VALUE
        from
         (select USTC.STATSYEAR,
            case USTC.TABLE_NUMBER
              when '2' then 'ASRT2'
              when '3' then 'ASRT3'
              when '4' then 'ASRT4'
              when '5' then 'ASRT5'
              when '6A' then 'ASRT6AB'
              when '6B' then 'ASRT6AB'
              when '6C' then 'ASRT6C'
              when '6D' then 'ASRT6D'
              when '7A' then 'ASRT7AB'
              when '7B' then 'ASRT7AB'
              when '7C' then 'ASRT7C'
              when '7D' then 'ASRT7D'
            end as STTG_CODE,
            USTC.DST_CODE, USTC.COU_CODE_ASYLUM,
            case
              when upper(USTC.LOCATION_NAME) = 'VARIOUS' then COU.NAME
              else trim(regexp_replace(USTC.LOCATION_NAME, ':.*$', ''))
            end as LOCATION_NAME,
            decode(USTC.COU_CODE_ORIGIN, 'YUG', 'SRB', USTC.COU_CODE_ORIGIN) as COU_CODE_ORIGIN,
            USTC.DIMT_CODE1, USTC.DIM_CODE1, USTC.DIMT_CODE2, USTC.DIM_CODE2, USTC.DIMT_CODE3,
            USTC.DIM_CODE3, USTC.DIMT_CODE4, USTC.DIM_CODE4, USTC.DIMT_CODE5, USTC.DIM_CODE5,
            USTC.SUBGROUP_NAME, USTC.PPG_NAME, USTC.SOURCE, USTC.BASIS,
            USTC.PERIOD_FLAG, USTC.STCT_CODE, USTC.SEX_CODE, USTC.AGE_FROM,
            USTC.VALUE
          from UNPIVOTED_STATISTICS USTC
          left outer join COUNTRIES COU
            on COU.UNHCR_COUNTRY_CODE = USTC.COU_CODE_ASYLUM
          where VALUE != 0))
      group by STTG_CODE, STATSYEAR, DST_CODE,
        COU_CODE_ASYLUM, LOCATION_NAME, COU_CODE_ORIGIN,
        DIMT_CODE1, DIM_CODE1, DIMT_CODE2, DIM_CODE2, DIMT_CODE3, DIM_CODE3,
        DIMT_CODE4, DIM_CODE4, DIMT_CODE5, DIM_CODE5, SUBGROUP_NAME,
        PPG_NAME, PPG_COUNT, SOURCE, BASIS,
        PERIOD_FLAG, STCT_CODE, SEX_CODE, AGE_FROM)
  --
    select STC.STATSYEAR,
      STC.STTG_CODE,
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
      STC.DIMT_CODE3,
      STC.DIM_CODE3,
      STC.DIMT_CODE4,
      STC.DIM_CODE4,
      STC.DIMT_CODE5,
      STC.DIM_CODE5,
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
      DST.ID as DST_ID,
      nvl(COU.ID, case when STC.COU_CODE_ASYLUM != 'VAR' then -1 end) as LOC_ID_ASYLUM_COUNTRY,
      LOC.LOC_ID as LOC_ID_ASYLUM,
      nvl(OGN.ID, case when STC.COU_CODE_ORIGIN != 'VAR' then -1 end) as LOC_ID_ORIGIN_COUNTRY,
      DIM1.ID as DIM_ID1,
      DIM2.ID as DIM_ID2,
      DIM3.ID as DIM_ID3,
      DIM4.ID as DIM_ID4,
      DIM5.ID as DIM_ID5,
      AGR.ID as AGR_ID,
      case when STC.STTG_CODE = 'ASRT7AB' then OGN.ID else COU.ID end as LOC_ID_REPORTING_COUNTRY,
      row_number() over
       (partition by STC.STATSYEAR, STC.STTG_CODE, STC.DST_CODE, COU.ID, LOC.LOC_ID, OGN.ID,
          DIM1.ID, DIM2.ID, DIM3.ID, DIM4.ID, DIM5.ID,
          nvl(STC.SUBGROUP_NAME, case when STC.PPG_COUNT > 1 then STC.PPG_NAME end),
          nvl(PPG1.PPG_ID, PPG2.PPG_ID)
        order by STC.PERIOD_FLAG, STC.STCT_CODE, STC.SEX_CODE, AGR.ID) as PSG_CHILD_NUMBER
    from AGGREGATED_STATISTICS STC
    left outer join T_DISPLACEMENT_STATUSES DST
      on DST.CODE = STC.DST_CODE
      and DST.START_DATE < STC.END_DATE_YEAR
      and DST.END_DATE >= STC.END_DATE_YEAR
    left outer join
     (select LOC.ID, LOC.START_DATE, LOC.END_DATE, LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE
      from T_LOCATIONS LOC
      inner join T_LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = LOC.ID
        and LOCA.LOCAT_CODE = 'HCRCC'
      where LOC.LOCT_CODE = 'COUNTRY') COU
      on COU.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and COU.START_DATE < STC.END_DATE_YEAR
      and COU.END_DATE >= STC.END_DATE_YEAR
    left outer join
     (select LOCR.LOC_ID_FROM, LOCR.LOCRT_CODE, LOCR.START_DATE, LOCR.END_DATE,
        LOC.ID LOC_ID, LOC.NAME
      from LOCATION_RELATIONSHIPS LOCR
      join LOCATIONS LOC
        on LOC.ID = LOCR.LOC_ID_TO) LOC
      on LOC.LOC_ID_FROM = COU.ID
      and LOC.LOCRT_CODE = 'WITHIN'
      and LOC.START_DATE < STC.END_DATE_YEAR
      and LOC.END_DATE >= STC.END_DATE_YEAR
      and LOC.NAME = STC.LOCATION_NAME
    left outer join
     (select LOC.ID, LOC.START_DATE, LOC.END_DATE, LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE
      from T_LOCATIONS LOC
      inner join T_LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = LOC.ID
        and LOCA.LOCAT_CODE = 'HCRCC'
      where LOC.LOCT_CODE in ('COUNTRY', 'OTHORIGIN')) OGN
      on OGN.UNHCR_COUNTRY_CODE = STC.COU_CODE_ORIGIN
      and OGN.START_DATE < STC.END_DATE_YEAR
      and OGN.END_DATE >= STC.END_DATE_YEAR
    left outer join T_DIMENSION_VALUES DIM1
      on DIM1.DIMT_CODE = STC.DIMT_CODE1
      and DIM1.CODE = STC.DIM_CODE1
      and DIM1.START_DATE < STC.END_DATE_YEAR
      and DIM1.END_DATE >= STC.END_DATE_YEAR
    left outer join T_DIMENSION_VALUES DIM2
      on DIM2.DIMT_CODE = STC.DIMT_CODE2
      and DIM2.CODE = STC.DIM_CODE2
      and DIM2.START_DATE < STC.END_DATE_YEAR
      and DIM2.END_DATE >= STC.END_DATE_YEAR
    left outer join T_DIMENSION_VALUES DIM3
      on DIM3.DIMT_CODE = STC.DIMT_CODE3
      and DIM3.CODE = STC.DIM_CODE3
      and DIM3.START_DATE < STC.END_DATE_YEAR
      and DIM3.END_DATE >= STC.END_DATE_YEAR
    left outer join T_DIMENSION_VALUES DIM4
      on DIM4.DIMT_CODE = STC.DIMT_CODE4
      and DIM4.CODE = STC.DIM_CODE4
      and DIM4.START_DATE < STC.END_DATE_YEAR
      and DIM4.END_DATE >= STC.END_DATE_YEAR
    left outer join T_DIMENSION_VALUES DIM5
      on DIM5.DIMT_CODE = STC.DIMT_CODE5
      and DIM5.CODE = STC.DIM_CODE5
      and DIM5.START_DATE < STC.END_DATE_YEAR
      and DIM5.END_DATE >= STC.END_DATE_YEAR
    left outer join
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, PPG.ID as PPG_ID, PPG.DESCRIPTION as PPG_NAME,
        greatest(LOC.START_DATE, PPG.START_DATE) as START_DATE,
        least(LOC.END_DATE, PPG.END_DATE) as END_DATE
      from T_LOCATIONS LOC
      inner join T_LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = LOC.ID
        and LOCA.LOCAT_CODE = 'HCRCC'
      inner join POPULATION_PLANNING_GROUPS PPG
        on PPG.LOC_ID = LOC.ID
      where LOC.LOCT_CODE = 'COUNTRY') PPG1
      on PPG1.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and PPG1.PPG_NAME = STC.PPG_NAME
      and PPG1.START_DATE < STC.END_DATE_YEAR
      and PPG1.END_DATE >= STC.END_DATE_YEAR
    left outer join
     (select LOCA.CHAR_VALUE as UNHCR_COUNTRY_CODE, PPG.ID as PPG_ID, PPG.DESCRIPTION as PPG_NAME,
        greatest(LOC1.START_DATE, LOC2.START_DATE, PPG.START_DATE) as START_DATE,
        least(LOC1.END_DATE, LOC2.END_DATE, PPG.END_DATE) as END_DATE
      from T_LOCATIONS LOC1
      inner join T_LOCATION_ATTRIBUTES LOCA
        on LOCA.LOC_ID = LOC1.ID
        and LOCA.LOCAT_CODE = 'HCRCC'
      inner join LOCATION_RELATIONSHIPS LOCR
        on LOCR.LOC_ID_TO = LOC1.ID
        and LOCR.LOCRT_CODE = 'HCRRESP'
      inner join LOCATIONS LOC2
        on LOC2.ID = LOCR.LOC_ID_FROM
        and LOC2.LOCT_CODE = 'HCR-ROF'
      inner join POPULATION_PLANNING_GROUPS PPG
        on PPG.LOC_ID = LOC2.ID) PPG2
      on PPG2.UNHCR_COUNTRY_CODE = STC.COU_CODE_ASYLUM
      and PPG2.PPG_NAME = STC.PPG_NAME
      and PPG2.START_DATE < STC.END_DATE_YEAR
      and PPG2.END_DATE >= STC.END_DATE_YEAR
    left outer join T_AGE_RANGES AGR
      on AGR.AGP_CODE = 'STD'
      and AGR.AGE_FROM = STC.AGE_FROM
    order by STATSYEAR, LOC_ID_REPORTING_COUNTRY, STTG_CODE,
      DST_CODE, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5, SUBGROUP_NAME,
      PPG_ID, PERIOD_FLAG, STCT_CODE, SEX_CODE, AGR_ID)
  loop
    P_UTILITY.TRACE_POINT
     ('Trace',
      rSTC.STATSYEAR || '~' || rSTC.STTG_CODE || '~' || rSTC.DST_CODE || '~' ||
        rSTC.COU_CODE_ASYLUM || '~' || rSTC.LOCATION_NAME || '~' || rSTC.COU_CODE_ORIGIN || '~' ||
        rSTC.DIMT_CODE1 || '~' || rSTC.DIM_CODE1 || '~' ||
        rSTC.DIMT_CODE2 || '~' || rSTC.DIM_CODE2 || '~' ||
        rSTC.DIMT_CODE3 || '~' || rSTC.DIM_CODE3 || '~' ||
        rSTC.DIMT_CODE4 || '~' || rSTC.DIM_CODE4 || '~' ||
        rSTC.DIMT_CODE5 || '~' || rSTC.DIM_CODE5 || '~' ||
        rSTC.SUBGROUP_NAME || '~' || rSTC.PPG_NAME || '~' || rSTC.STCT_CODE || '~' ||
        rSTC.PERIOD_FLAG || '~' || rSTC.SEX_CODE || '~' || to_char(rSTC.AGE_FROM));
  --
    if rSTC.LOC_ID_ASYLUM_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid country of asylum: ' || rSTC.STTG_CODE || '~' || rSTC.STATSYEAR || '~' ||
          rSTC.COU_CODE_ASYLUM);
    elsif rSTC.LOC_ID_ORIGIN_COUNTRY = -1
    then
      dbms_output.put_line
       ('Invalid origin: ' || rSTC.STTG_CODE || '~' || rSTC.STATSYEAR || '~' ||
          rSTC.COU_CODE_ORIGIN);
    else
    --
    -- Create statistic group for the whole country's statistics.
    --
      if rSTC.STATSYEAR = sSTATSYEAR and rSTC.LOC_ID_REPORTING_COUNTRY = nLOC_ID_REPORTING_COUNTRY
      then null;
      else
        sSTATSYEAR := rSTC.STATSYEAR;
        nLOC_ID_REPORTING_COUNTRY := rSTC.LOC_ID_REPORTING_COUNTRY;
        sSTTG_CODE := null;
      --
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID_COUNTRY, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_REPORTING_COUNTRY);
        iCount1 := iCount1 + 1;
      end if;
    --
    -- Create statistic group for the statistics in each table in each country.
    --
      if rSTC.STTG_CODE = sSTTG_CODE
      then null;
      else
        sSTTG_CODE := rSTC.STTG_CODE;
      --
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID_TABLE, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psSTTG_CODE => rSTC.STTG_CODE,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_REPORTING_COUNTRY);
        iCount1 := iCount1 + 1;
      end if;
    --
      if rSTC.PSG_CHILD_NUMBER = 1
      then
        P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP
         (nSTG_ID, rSTC.START_DATE_YEAR, rSTC.END_DATE_YEAR,
          psSTTG_CODE => rSTC.STTG_CODE,
          pnDST_ID => rSTC.DST_ID,
          pnLOC_ID_ASYLUM_COUNTRY => rSTC.LOC_ID_ASYLUM_COUNTRY,
          pnLOC_ID_ASYLUM => rSTC.LOC_ID_ASYLUM,
          pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
          pnDIM_ID1 => rSTC.DIM_ID1,
          pnDIM_ID2 => rSTC.DIM_ID2,
          pnDIM_ID3 => rSTC.DIM_ID3,
          pnDIM_ID4 => rSTC.DIM_ID4,
          pnDIM_ID5 => rSTC.DIM_ID5,
          psLANG_CODE => case when rSTC.SUBGROUP_NAME is not null then 'en' end,
          psSUBGROUP_NAME => rSTC.SUBGROUP_NAME,
          pnPPG_ID => rSTC.PPG_ID);
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
        pnLOC_ID_ASYLUM => rSTC.LOC_ID_ASYLUM,
        pnLOC_ID_ORIGIN_COUNTRY => rSTC.LOC_ID_ORIGIN_COUNTRY,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnDIM_ID3 => rSTC.DIM_ID3,
        pnDIM_ID4 => rSTC.DIM_ID4,
        pnDIM_ID5 => rSTC.DIM_ID5,
        psSEX_CODE => rSTC.SEX_CODE,
        pnAGR_ID => rSTC.AGR_ID,
        pnSTG_ID_PRIMARY => nSTG_ID,
        pnPPG_ID => rSTC.PPG_ID,
        pnVALUE => rSTC.VALUE);
      iCount2 := iCount2 + 1;
    --
    -- Link this statistic to the groups for its table and country.
    --
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_COUNTRY);
      P_STATISTIC.INSERT_STATISTIC_IN_GROUP(nSTC_ID, nSTG_ID_TABLE);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount1) || ' statistic group records inserted');
  dbms_output.put_line(to_char(iCount2) || ' statistic records inserted');
--
  P_UTILITY.END_MODULE;
  --P_UTILITY.DISABLE_TRACE;
  --P_UTILITY.CLOSE_LOG;
end;
/
