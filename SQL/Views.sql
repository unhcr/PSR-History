create or replace view L_PIVOTED_STATISTICS
as
select COUNTRY_CODE, UNHCR_COUNTRY_CODE, LOC_NAME_COUNTRY,
  LOC_NAME,
  URBAN_RURAL,
  ACCOMMODATION_TYPE,
  POPC_CODE,
  POPC_DESCRIPTION,
  OGN_CODE, OGN_NAME, UNHCR_OGN_CODE,
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
 (select COUNTRY_CODE, UNHCR_COUNTRY_CODE, LOC_NAME_COUNTRY,
    LOC_NAME,
    case when DIMT_CODE1 = 'UR' then DIM_DESCRIPTION1 end URBAN_RURAL,
    case when DIMT_CODE2 = 'ACMT' then DIM_DESCRIPTION2 end ACCOMMODATION_TYPE,
    POPC_CODE,
    POPC_DESCRIPTION,
    OGN_CODE, OGN_NAME, UNHCR_OGN_CODE,
    nvl(SEX_CODE, 'X') SEX_CODE,
    nvl(AGE_FROM, -1) AGE_FROM,
    VALUE
  from L_STATISTICS)
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
