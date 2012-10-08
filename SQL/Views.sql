create or replace view PIVOTED_STATISTICS
as
select ISO_COUNTRY_CODE COUNTRY_CODE, UNHCR_COUNTRY_CODE,
  LOC_NAME_ASYLUM_COUNTRY, LOC_NAME_ASYLUM,
  URBAN_RURAL,
  ACCOMMODATION_TYPE,
  DST_CODE,
  DST_DESCRIPTION,
  ISO_ORIGIN_CODE, UNHCR_ORIGIN_CODE, LOC_NAME_ORIGIN OGN_NAME,
  FEMALE_0_4,
  FEMALE_5_11,
  FEMALE_12_17,
  FEMALE_18_59,
  FEMALE_60_PLUS,
  FEMALE_UNSPECIFIED,
  case
    when nvl(FEMALE_0_4, 0) + nvl(FEMALE_5_11, 0) + nvl(FEMALE_12_17, 0) + nvl(FEMALE_18_59, 0) + nvl(FEMALE_60_PLUS, 0) + nvl(FEMALE_UNSPECIFIED, 0) > 0
    then nvl(FEMALE_0_4, 0) + nvl(FEMALE_5_11, 0) + nvl(FEMALE_12_17, 0) + nvl(FEMALE_18_59, 0) + nvl(FEMALE_60_PLUS, 0) + nvl(FEMALE_UNSPECIFIED, 0)
  end FEMALE_TOTAL,
  MALE_0_4,
  MALE_5_11,
  MALE_12_17,
  MALE_18_59,
  MALE_60_PLUS,
  MALE_UNSPECIFIED,
  case
    when nvl(MALE_0_4, 0) + nvl(MALE_5_11, 0) + nvl(MALE_12_17, 0) + nvl(MALE_18_59, 0) + nvl(MALE_60_PLUS, 0) + nvl(MALE_UNSPECIFIED, 0) > 0
    then nvl(MALE_0_4, 0) + nvl(MALE_5_11, 0) + nvl(MALE_12_17, 0) + nvl(MALE_18_59, 0) + nvl(MALE_60_PLUS, 0) + nvl(MALE_UNSPECIFIED, 0)
  end MALE_TOTAL,
  UNSPECIFIED,
  nvl(FEMALE_0_4, 0) + nvl(FEMALE_5_11, 0) + nvl(FEMALE_12_17, 0) + nvl(FEMALE_18_59, 0) +
    nvl(FEMALE_60_PLUS, 0) + nvl(FEMALE_UNSPECIFIED, 0) +
    nvl(MALE_0_4, 0) + nvl(MALE_5_11, 0) + nvl(MALE_12_17, 0) + nvl(MALE_18_59, 0) +
    nvl(MALE_60_PLUS, 0) + nvl(MALE_UNSPECIFIED, 0) +
    nvl(UNSPECIFIED, 0) TOTAL
from
 (select ISO_COUNTRY_CODE, UNHCR_COUNTRY_CODE, LOC_NAME_ASYLUM_COUNTRY,
    LOC_NAME_ASYLUM,
    case when DIMT_CODE1 = 'UR' then DIM_DESCRIPTION1 end URBAN_RURAL,
    case when DIMT_CODE2 = 'ACMT' then DIM_DESCRIPTION2 end ACCOMMODATION_TYPE,
    DST_CODE,
    DST_DESCRIPTION,
    ISO_ORIGIN_CODE, UNHCR_ORIGIN_CODE, LOC_NAME_ORIGIN,
    nvl(SEX_CODE, 'X') SEX_CODE,
    nvl(AGE_FROM, -1) AGE_FROM,
    VALUE
  from STATISTICS)
pivot
 (sum(VALUE)
  for (SEX_CODE, AGE_FROM)
  in (('F', 0) as FEMALE_0_4,
    ('F', 5) as FEMALE_5_11,
    ('F', 12) as FEMALE_12_17,
    ('F', 18) as FEMALE_18_59,
    ('F', 60) as FEMALE_60_PLUS,
    ('F', -1) as FEMALE_UNSPECIFIED,
    ('M', 0) as MALE_0_4,
    ('M', 5) as MALE_5_11,
    ('M', 12) as MALE_12_17,
    ('M', 18) as MALE_18_59,
    ('M', 60) as MALE_60_PLUS,
    ('M', -1) as MALE_UNSPECIFIED,
    ('X', -1) as UNSPECIFIED));

create or replace view ASR_TABLE2
as
select STATSYEAR,
  DST_CODE, DST_DESCRIPTION,
  ISO_COUNTRY_CODE, UNHCR_COUNTRY_CODE, LOC_NAME_ASYLUM_COUNTRY,
  ISO_ORIGIN_CODE, UNHCR_ORIGIN_CODE, LOC_NAME_ORIGIN_COUNTRY,
  POP_START_VALUE, POP_START_STC_ID, POP_START_ITM_ID,
  POP_AH_START_VALUE, POP_AH_START_STC_ID, POP_AH_START_ITM_ID,
  ARR_GRP_VALUE, ARR_GRP_STC_ID, ARR_GRP_ITM_ID,
  ARR_IND_VALUE, ARR_IND_STC_ID, ARR_IND_ITM_ID,
  ARR_RESTL_VALUE, ARR_RESTL_STC_ID, ARR_RESTL_ITM_ID,
  BIRTH_VALUE, BIRTH_STC_ID, BIRTH_ITM_ID,
  REFOTHINC_VALUE, REFOTHINC_STC_ID, REFOTHINC_ITM_ID,
  case
    when coalesce(ARR_GRP_VALUE, ARR_IND_VALUE, ARR_RESTL_VALUE,
                  BIRTH_VALUE, REFOTHINC_VALUE) is not null
    then nvl(ARR_GRP_VALUE, 0) + nvl(ARR_IND_VALUE, 0) + nvl(ARR_RESTL_VALUE, 0) +
      nvl(BIRTH_VALUE, 0) + nvl(REFOTHINC_VALUE, 0)
  end TOTAL_INCREASE,
  VOLREP_VALUE, VOLREP_STC_ID, VOLREP_ITM_ID,
  VOLREP_AH_VALUE, VOLREP_AH_STC_ID, VOLREP_AH_ITM_ID,
  RESTL_VALUE, RESTL_STC_ID, RESTL_ITM_ID,
  RESTL_AH_VALUE, RESTL_AH_STC_ID, RESTL_AH_ITM_ID,
  CESSATION_VALUE, CESSATION_STC_ID, CESSATION_ITM_ID,
  NATURLZN_VALUE, NATURLZN_STC_ID, NATURLZN_ITM_ID,
  DEATH_VALUE, DEATH_STC_ID, DEATH_ITM_ID,
  REFOTHDEC_VALUE, REFOTHDEC_STC_ID, REFOTHDEC_ITM_ID,
  case
    when coalesce(VOLREP_VALUE, RESTL_VALUE, CESSATION_VALUE,
                  NATURLZN_VALUE, DEATH_VALUE, REFOTHDEC_VALUE) is not null
    then nvl(VOLREP_VALUE, 0) + nvl(RESTL_VALUE, 0) + nvl(CESSATION_VALUE, 0) +
      nvl(NATURLZN_VALUE, 0) + nvl(DEATH_VALUE, 0) + nvl(REFOTHDEC_VALUE, 0)
  end TOTAL_DECREASE,
  POP_END_VALUE, POP_END_STC_ID, POP_END_ITM_ID,
  POP_AH_END_VALUE, POP_AH_END_STC_ID, POP_AH_END_ITM_ID,
  SOURCE, BASIS
from UP_ASR_TABLE2
pivot
 (sum(VALUE) as VALUE, max(STC_ID) as STC_ID, max(ITM_ID) as ITM_ID
  for COLUMN_NAME
  in ('POP_START' as POP_START,
      'POP_AH_START' as POP_AH_START,
      'ARR_GRP' as ARR_GRP,
      'ARR_IND' as ARR_IND,
      'ARR_RESTL' as ARR_RESTL,
      'BIRTH' as BIRTH,
      'REFOTHINC' as REFOTHINC,
      'VOLREP' as VOLREP,
      'VOLREP_AH' as VOLREP_AH,
      'RESTL' as RESTL,
      'RESTL_AH' as RESTL_AH,
      'CESSATION' as CESSATION,
      'NATURLZN' as NATURLZN,
      'DEATH' as DEATH,
      'REFOTHDEC' as REFOTHDEC,
      'POP_END' as POP_END,
      'POP_AH_END' as POP_AH_END));

create or replace view ASR_TABLE3 as
with Q_ASR_TABLE3 as
 (select PER_ID, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM,
    DIM_ID1, DIM_ID2, DST_CODE, LOC_ID_ORIGIN_COUNTRY,
    F0_4_VALUE, F0_4_STC_ID, F0_4_ITM_ID,
    F5_11_VALUE, F5_11_STC_ID, F5_11_ITM_ID,
    F12_17_VALUE, F12_17_STC_ID, F12_17_ITM_ID,
    F18_59_VALUE, F18_59_STC_ID, F18_59_ITM_ID,
    F60_VALUE, F60_STC_ID, F60_ITM_ID,
    FOTHER_VALUE, FOTHER_STC_ID, FOTHER_ITM_ID,
    M0_4_VALUE, M0_4_STC_ID, M0_4_ITM_ID,
    M5_11_VALUE, M5_11_STC_ID, M5_11_ITM_ID,
    M12_17_VALUE, M12_17_STC_ID, M12_17_ITM_ID,
    M18_59_VALUE, M18_59_STC_ID, M18_59_ITM_ID,
    M60_VALUE, M60_STC_ID, M60_ITM_ID,
    MOTHER_VALUE, MOTHER_STC_ID, MOTHER_ITM_ID,
    TOTAL_VALUE, TOTAL_STC_ID, TOTAL_ITM_ID
  from
   (select STC.DST_CODE, STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ASYLUM, STC.LOC_ID_ORIGIN_COUNTRY,
      STC.DIM_ID1, STC.DIM_ID2, STC.PER_ID,
      STC.SEX_CODE || nvl(to_char(AGR.AGE_FROM), 'X') ||
        case when AGR.AGE_TO != 999 then '_' || to_char(AGR.AGE_TO) end as COLUMN_NAME,
      STC.VALUE,
      STC.ID as STC_ID,
      STC.ITM_ID
    from T_STATISTIC_TYPES_IN_GROUPS STCTG
    inner join T_STATISTICS STC
      on STC.STCT_CODE = STCTG.STCT_CODE
    left outer join T_AGE_RANGES AGR
      on AGR.ID = STC.AGR_ID
    where STCTG.STCG_CODE = 'ASRT3')
  pivot
   (sum(VALUE) as VALUE, max(STC_ID) as STC_ID, max(ITM_ID) as ITM_ID
    for COLUMN_NAME
    in ('F0_4' as F0_4,
        'F5_11' as F5_11,
        'F12_17' as F12_17,
        'F18_59' as F18_59,
        'F60' as F60,
        'FX' as FOTHER,
        'M0_4' as M0_4,
        'M5_11' as M5_11,
        'M12_17' as M12_17,
        'M18_59' as M18_59,
        'M60' as M60,
        'MX' as MOTHER,
        'X' as TOTAL))),
--
Q_LOCATIONS as
 (select ID, NAME, LANG_CODE, LOCT_CODE, LOCTV_ID, START_DATE, END_DATE, ITM_ID, VERSION_NBR
  from
   (select LOC.ID, TXT.TEXT as NAME, TXT.LANG_CODE, LOC.LOCT_CODE, LOC.LOCTV_ID, LOC.START_DATE,
      LOC.END_DATE, LOC.ITM_ID, LOC.VERSION_NBR,
      row_number() over
       (partition by LOC.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATIONS LOC
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOC.ITM_ID
      and TXT.TXTT_CODE = 'NAME'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_LOCATION_TYPES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select LOCT.CODE, TXT.TEXT DESCRIPTION, TXT.LANG_CODE, LOCT.DISPLAY_SEQ, LOCT.ACTIVE_FLAG,
      LOCT.ITM_ID, LOCT.VERSION_NBR,
      row_number() over
       (partition by LOCT.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATION_TYPES LOCT
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOCT.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_LOCATION_TYPE_VARIANTS as
 (select ID, DESCRIPTION, LANG_CODE, LOCT_CODE, LOC_ID, LOCRT_CODE, DISPLAY_SEQ, ACTIVE_FLAG,
    ITM_ID, VERSION_NBR
  from
    (select LOCTV.ID, TXT.TEXT DESCRIPTION, TXT.LANG_CODE, LOCTV.LOCT_CODE, LOCTV.LOC_ID,
      LOCTV.LOCRT_CODE, LOCTV.DISPLAY_SEQ, LOCTV.ACTIVE_FLAG, LOCTV.ITM_ID, LOCTV.VERSION_NBR,
      row_number() over
       (partition by LOCTV.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_LOCATION_TYPE_VARIANTS LOCTV
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = LOCTV.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_DIMENSION_VALUES as
 (select ID, DESCRIPTION, LANG_CODE, DIMT_CODE, CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select DIM.ID, TXT.TEXT DESCRIPTION, TXT.LANG_CODE, DIM.DIMT_CODE, DIM.CODE, DIM.DISPLAY_SEQ,
      DIM.ACTIVE_FLAG, DIM.ITM_ID, DIM.VERSION_NBR,
      row_number() over
       (partition by DIM.ID
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DIMENSION_VALUES DIM
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DIM.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID'))
  where RANK = 1),
--
Q_DISPLACEMENT_STATUSES as
 (select CODE, DESCRIPTION, LANG_CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID, VERSION_NBR
  from
   (select DST.CODE, TXT.TEXT DESCRIPTION, TXT.LANG_CODE, DST.DISPLAY_SEQ, DST.ACTIVE_FLAG,
      DST.ITM_ID, DST.VERSION_NBR,
      row_number() over
       (partition by DST.CODE
        order by LANG.ACTIVE_FLAG desc, nvl(ULP.PREF_SEQ, LANG.DISPLAY_SEQ + 1e5)) as RANK
    from T_DISPLACEMENT_STATUSES DST
    inner join T_TEXT_ITEMS TXT
      on TXT.ITM_ID = DST.ITM_ID
      and TXT.TXTT_CODE = 'DESCR'
      and TXT.SEQ_NBR = 1
    inner join T_LANGUAGES LANG
      on LANG.CODE = TXT.LANG_CODE
    left outer join T_USER_LANGUAGE_PREFERENCES ULP
      on ULP.LANG_CODE = TXT.LANG_CODE
      and ULP.USERID = sys_context('PSR', 'USERID')
    )
  where RANK = 1)
--
select extract(year from PER.START_DATE) as STATSYEAR,
  LOCA1.CHAR_VALUE as ISO_COUNTRY_CODE,
  LOCA2.CHAR_VALUE as UNHCR_COUNTRY_CODE,
  LOC1.NAME as LOC_NAME_ASYLUM_COUNTRY,
  LOC2.NAME as LOC_NAME_ASYLUM,
  nvl(LOCTV.DESCRIPTION, LOCT.DESCRIPTION) as LOC_TYPE_DESCRIPTION,
  DIM1.CODE as UR_CODE,
  DIM1.DESCRIPTION as UR_DESCRIPTION,
  DIM2.CODE as ACMT_CODE,
  DIM2.DESCRIPTION as ACMT_DESCRIPTION,
  AT3.DST_CODE,
  DST.DESCRIPTION as DST_DESCRIPTION,
  LOCA3.CHAR_VALUE as ISO_ORIGIN_CODE,
  LOCA4.CHAR_VALUE as UNHCR_ORIGIN_CODE,
  LOC3.NAME as LOC_NAME_ORIGIN_COUNTRY,
  AT3.F0_4_VALUE, AT3.F0_4_STC_ID, AT3.F0_4_ITM_ID,
  AT3.F5_11_VALUE, AT3.F5_11_STC_ID, AT3.F5_11_ITM_ID,
  AT3.F12_17_VALUE, AT3.F12_17_STC_ID, AT3.F12_17_ITM_ID,
  AT3.F18_59_VALUE, AT3.F18_59_STC_ID, AT3.F18_59_ITM_ID,
  AT3.F60_VALUE, AT3.F60_STC_ID, AT3.F60_ITM_ID,
  case
    when coalesce(AT3.F0_4_VALUE, AT3.F5_11_VALUE, AT3.F12_17_VALUE,
                  AT3.F18_59_VALUE, AT3.F60_VALUE) is not null
    then AT3.FOTHER_VALUE
  end as FOTHER_VALUE,
  case
    when coalesce(AT3.F0_4_STC_ID, AT3.F5_11_STC_ID, AT3.F12_17_STC_ID,
                  AT3.F18_59_STC_ID, AT3.F60_STC_ID) is not null
    then AT3.FOTHER_STC_ID
  end as FOTHER_STC_ID,
  case
    when coalesce(AT3.F0_4_STC_ID, AT3.F5_11_STC_ID, AT3.F12_17_STC_ID,
                  AT3.F18_59_STC_ID, AT3.F60_STC_ID) is not null
    then AT3.FOTHER_ITM_ID
  end as FOTHER_ITM_ID,
  case
    when coalesce(AT3.F0_4_STC_ID, AT3.F5_11_STC_ID, AT3.F12_17_STC_ID,
                  AT3.F18_59_STC_ID, AT3.F60_STC_ID, AT3.FOTHER_VALUE) is not null
    then nvl(AT3.F0_4_VALUE, 0) + nvl(AT3.F5_11_VALUE, 0) + nvl(AT3.F12_17_VALUE, 0) +
      nvl(AT3.F18_59_VALUE, 0) + nvl(AT3.F60_VALUE, 0) + nvl(AT3.FOTHER_VALUE, 0)
  end as FTOTAL_VALUE,
  case
    when coalesce(AT3.F0_4_STC_ID, AT3.F5_11_STC_ID, AT3.F12_17_STC_ID,
                  AT3.F18_59_STC_ID, AT3.F60_STC_ID) is null
    then AT3.FOTHER_STC_ID
  end as FTOTAL_STC_ID,
  case
    when coalesce(AT3.F0_4_STC_ID, AT3.F5_11_STC_ID, AT3.F12_17_STC_ID,
                  AT3.F18_59_STC_ID, AT3.F60_STC_ID) is null
    then AT3.FOTHER_ITM_ID
  end as FTOTAL_ITM_ID,
  AT3.M0_4_VALUE, AT3.M0_4_STC_ID, AT3.M0_4_ITM_ID,
  AT3.M5_11_VALUE, AT3.M5_11_STC_ID, AT3.M5_11_ITM_ID,
  AT3.M12_17_VALUE, AT3.M12_17_STC_ID, AT3.M12_17_ITM_ID,
  AT3.M18_59_VALUE, AT3.M18_59_STC_ID, AT3.M18_59_ITM_ID,
  AT3.M60_VALUE, AT3.M60_STC_ID, AT3.M60_ITM_ID,
  case
    when coalesce(AT3.M0_4_VALUE, AT3.M5_11_VALUE, AT3.M12_17_VALUE,
                  AT3.M18_59_VALUE, AT3.M60_VALUE) is not null
    then AT3.MOTHER_VALUE
  end as MOTHER_VALUE,
  case
    when coalesce(AT3.M0_4_STC_ID, AT3.M5_11_STC_ID, AT3.M12_17_STC_ID,
                  AT3.M18_59_STC_ID, AT3.M60_STC_ID) is not null
    then AT3.MOTHER_STC_ID
  end as MOTHER_STC_ID,
  case
    when coalesce(AT3.M0_4_STC_ID, AT3.M5_11_STC_ID, AT3.M12_17_STC_ID,
                  AT3.M18_59_STC_ID, AT3.M60_STC_ID) is not null
    then AT3.MOTHER_ITM_ID
  end as MOTHER_ITM_ID,
  case
    when coalesce(AT3.M0_4_STC_ID, AT3.M5_11_STC_ID, AT3.M12_17_STC_ID,
                  AT3.M18_59_STC_ID, AT3.M60_STC_ID, AT3.MOTHER_VALUE) is not null
    then nvl(AT3.M0_4_VALUE, 0) + nvl(AT3.M5_11_VALUE, 0) + nvl(AT3.M12_17_VALUE, 0) +
      nvl(AT3.M18_59_VALUE, 0) + nvl(AT3.M60_VALUE, 0) + nvl(AT3.MOTHER_VALUE, 0)
  end as MTOTAL_VALUE,
  case
    when coalesce(AT3.M0_4_STC_ID, AT3.M5_11_STC_ID, AT3.M12_17_STC_ID,
                  AT3.M18_59_STC_ID, AT3.M60_STC_ID) is null
    then AT3.MOTHER_STC_ID
  end as MTOTAL_STC_ID,
  case
    when coalesce(AT3.M0_4_STC_ID, AT3.M5_11_STC_ID, AT3.M12_17_STC_ID,
                  AT3.M18_59_STC_ID, AT3.M60_STC_ID) is null
    then AT3.MOTHER_ITM_ID
  end as MTOTAL_ITM_ID,
  nvl(AT3.TOTAL_VALUE,
      nvl(AT3.F0_4_VALUE, 0) + nvl(AT3.F5_11_VALUE, 0) + nvl(AT3.F12_17_VALUE, 0) +
      nvl(AT3.F18_59_VALUE, 0) + nvl(AT3.F60_VALUE, 0) + nvl(AT3.FOTHER_VALUE, 0) +
      nvl(AT3.M0_4_VALUE, 0) + nvl(AT3.M5_11_VALUE, 0) + nvl(AT3.M12_17_VALUE, 0) +
      nvl(AT3.M18_59_VALUE, 0) + nvl(AT3.M60_VALUE, 0) + nvl(AT3.MOTHER_VALUE, 0)) as TOTAL_VALUE,
  AT3.TOTAL_STC_ID, AT3.TOTAL_ITM_ID,
  PGRA.CHAR_VALUE AS BASIS
from Q_ASR_TABLE3 AT3
inner join T_TIME_PERIODS PER
  on PER.ID = AT3.PER_ID
inner join Q_LOCATIONS LOC1
  on LOC1.ID = AT3.LOC_ID_ASYLUM_COUNTRY
left outer join T_LOCATION_ATTRIBUTES LOCA1
  on LOCA1.LOC_ID = LOC1.ID
  and LOCA1.LOCAT_CODE = 'IS03166A3'
left outer join T_LOCATION_ATTRIBUTES LOCA2
  on LOCA2.LOC_ID = LOC1.ID
  and LOCA2.LOCAT_CODE = 'HCRCC'
inner join Q_LOCATIONS LOC2
  on LOC2.ID = AT3.LOC_ID_ASYLUM
inner join Q_LOCATION_TYPES LOCT
  on LOCT.CODE = LOC2.LOCT_CODE
left outer join Q_LOCATION_TYPE_VARIANTS LOCTV
  on LOCTV.ID = LOC2.LOCTV_ID
inner join Q_DIMENSION_VALUES DIM1
  on DIM1.ID = AT3.DIM_ID1
inner join Q_DIMENSION_VALUES DIM2
  on DIM2.ID = AT3.DIM_ID2
inner join Q_DISPLACEMENT_STATUSES DST
  on DST.CODE = AT3.DST_CODE
left outer join Q_LOCATIONS LOC3
  on LOC3.ID = AT3.LOC_ID_ORIGIN_COUNTRY
left outer join T_LOCATION_ATTRIBUTES LOCA3
  on LOCA3.LOC_ID = LOC3.ID
  and LOCA3.LOCAT_CODE = 'IS03166A3'
left outer join T_LOCATION_ATTRIBUTES LOCA4
  on LOCA4.LOC_ID = LOC3.ID
  and LOCA4.LOCAT_CODE = 'HCRCC'
left outer join T_POPULATION_GROUPS PGR
  on PGR.DST_CODE = AT3.DST_CODE
  and PGR.LOC_ID_ASYLUM_COUNTRY = AT3.LOC_ID_ASYLUM_COUNTRY
  and PGR.LOC_ID_ASYLUM = AT3.LOC_ID_ASYLUM
  and PGR.DIM_ID1 = AT3.DIM_ID1
  and PGR.DIM_ID2 = AT3.DIM_ID2
  and nvl(PGR.LOC_ID_ORIGIN_COUNTRY, 0) = nvl(AT3.LOC_ID_ORIGIN_COUNTRY, 0)
  --and PGR.PER_ID = AT3.PER_ID
  and PGR.LOC_ID_ORIGIN is null
  and PGR.DIM_ID3 is null
  and PGR.DIM_ID4 is null
  and PGR.DIM_ID5 is null
  and PGR.SEX_CODE is null
  and PGR.AGR_ID is null
  and PGR.SEQ_NBR is null
left outer join T_POP_GROUP_ATTRIBUTES PGRA
  on PGRA.PGR_ID = PGR.ID
  and PGRA.PGRAT_CODE = 'BASIS';