prompt Duplicate sub-locations
prompt =======================

select COU_CODE, COU_START_DATE, LOCATION_NAME_EN, LOCT_CODE, LOC_TYPE_DESCRIPTION_EN, count(*)
from S_LOCATION_SUBDIVISIONS
group by COU_CODE, COU_START_DATE, LOCATION_NAME_EN, LOCT_CODE, LOC_TYPE_DESCRIPTION_EN
having count(*) > 1
order by COU_CODE, COU_START_DATE, LOCATION_NAME_EN, LOCT_CODE, LOC_TYPE_DESCRIPTION_EN;

prompt Invalid sub-location parents
prompt ============================

select distinct COU_CODE, COU_START_DATE, LOCATION_NAME_EN, LOCT_CODE, LOC_TYPE_DESCRIPTION_EN, LOCATION_NAME_FROM
from S_LOCATION_SUBDIVISIONS
where LOCATION_NAME_FROM is not null
and (COU_CODE, LOCATION_NAME_FROM) not in
 (select COU_CODE, LOCATION_NAME_EN
  from S_LOCATION_SUBDIVISIONS)
order by COU_CODE, COU_START_DATE, LOCATION_NAME_EN, LOCT_CODE, LOC_TYPE_DESCRIPTION_EN;

prompt Redundant location name corrections
prompt ===================================

select COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME, CORRECTED_LOCATION_NAME
from S_LOCATION_NAME_CORRECTIONS
where CORRECTED_LOCATION_NAME = nvl(NEW_LOCATION_NAME, LOCATION_NAME)
order by COU_CODE, CORRECTED_LOCATION_NAME, LOCATION_NAME, NEW_LOCATION_NAME;

prompt Duplicate location name corrections
prompt ===================================

select COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME, sum(DUP_COUNT) as DUP_COUNT,
  listagg(CORRECTED_LOCATION_NAME, ' | ')
    within group (order by CORRECTED_LOCATION_NAME) as CORRECTED_LOCATION_NAME_LIST
from
 (select COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME, CORRECTED_LOCATION_NAME, count(*) as DUP_COUNT
  from S_LOCATION_NAME_CORRECTIONS
  group by COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME, CORRECTED_LOCATION_NAME)
group by COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME
having sum(DUP_COUNT) > 1
order by COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME;

prompt Invalid location name corrections
prompt =================================

select COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME, CORRECTED_LOCATION_NAME
from S_LOCATION_NAME_CORRECTIONS
where (COU_CODE, trim(regexp_replace(CORRECTED_LOCATION_NAME, ':.*$', ''))) not in
 (select COU_CODE, LOCATION_NAME_EN
  from S_LOCATION_SUBDIVISIONS)
order by COU_CODE, CORRECTED_LOCATION_NAME, LOCATION_NAME, NEW_LOCATION_NAME;

prompt Unused location name corrections
prompt ================================

select COU_CODE, LOCATION_NAME, NEW_LOCATION_NAME
from S_LOCATION_NAME_CORRECTIONS
minus
 (select COU_CODE_ASYLUM, replace(ORIGINAL_LOCATION_NAME, chr(10), '') as ORIGINAL_LOCATION_NAME,
    replace(NEW_LOCATION_NAME, chr(10), '') as NEW_LOCATION_NAME
  from S_ASR_DEMOGRAPHICS_CLEANED
  union
  select COU_CODE_ASYLUM, replace(ORIGINAL_LOCATION_NAME, chr(10), '') as ORIGINAL_LOCATION_NAME,
    null as NEW_LOCATION_NAME
  from S_ASR_IDPS_CLEANED);

prompt Missing location names or name corrections (Demographics)
prompt =========================================================

select COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
  ORIGINAL_LOCATION_NAME, NEW_LOCATION_NAME,
  listagg(STATSYEAR, ',') within group (order by STATSYEAR) as STATSYEARS
from
 (select distinct STATSYEAR, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    ORIGINAL_LOCATION_NAME, NEW_LOCATION_NAME
  from S_ASR_DEMOGRAPHICS_CLEANED
  where (COU_CODE_ASYLUM, LOCATION_NAME_EN) not in
   (select COU_CODE, LOCATION_NAME_EN
    from S_LOCATION_SUBDIVISIONS))
group by COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
  ORIGINAL_LOCATION_NAME, NEW_LOCATION_NAME
order by COU_CODE_ASYLUM, LOCATION_NAME_EN;

prompt Missing location names or name corrections (IDPs)
prompt =================================================

select COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, ORIGINAL_LOCATION_NAME,
  listagg(STATSYEAR, ',') within group (order by STATSYEAR) as STATSYEARS
from
 (select distinct STATSYEAR, COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN,
    ORIGINAL_LOCATION_NAME
  from S_ASR_IDPS_CLEANED
  where (COU_CODE_ASYLUM, LOCATION_NAME_EN) not in
   (select COU_CODE, LOCATION_NAME_EN
    from S_LOCATION_SUBDIVISIONS))
group by COU_CODE_ASYLUM, LOCATION_NAME_EN, LOC_TYPE_DESCRIPTION_EN, ORIGINAL_LOCATION_NAME
order by COU_CODE_ASYLUM, LOCATION_NAME_EN;

prompt Duplicate PPGs
prompt ==============

select PPG_CODE, START_DATE, count(*)
from S_PPGS
group by PPG_CODE, START_DATE
having count(*) > 1
order by PPG_CODE, START_DATE;

prompt Duplicate Country PPGs
prompt ======================

select COU_CODE, START_DATE, END_DATE, DESCRIPTION, LOCATION_NAME_EN, count(*)
from S_COUNTRY_PPGS
group by COU_CODE, START_DATE, END_DATE, DESCRIPTION, LOCATION_NAME_EN
having count(*) > 1
order by COU_CODE, START_DATE, END_DATE, DESCRIPTION, LOCATION_NAME_EN;

prompt Ambiguous PPGs
prompt ==============

select COU_CODE, START_DATE, END_DATE, DESCRIPTION, LOCATION_NAME_EN, PPG_CODE
from S_COUNTRY_PPGS CPG1
where exists
 (select null
  from S_COUNTRY_PPGS CPG2
  where CPG2.COU_CODE = CPG1.COU_CODE
  and CPG2.DESCRIPTION = CPG1.DESCRIPTION
  and (nvl(CPG2.LOCATION_NAME_EN, CPG1.LOCATION_NAME_EN) is null
    or CPG2.LOCATION_NAME_EN = CPG1.LOCATION_NAME_EN)
  and CPG2.START_DATE < CPG1.END_DATE
  and CPG2.END_DATE > CPG1.START_DATE
  and CPG2.rowid != CPG1.rowid);

prompt Invalid PPG Names
prompt =================

select distinct COU_CODE_ASYLUM, upper(PPG_NAME)
from S_ASR_DEMOGRAPHICS
where PPG_NAME is not null
minus
select COU_CODE, DESCRIPTION
from S_COUNTRY_PPGS;

/*
prompt Unused PPGs
prompt ===========

select PPG_CODE, START_DATE, END_DATE, DESCRIPTION
from S_PPGS
where DESCRIPTION not in
 (select PPG_NAME
  from S_ASR_DEMOGRAPHICS_CLEANED
  where PPG_NAME is not null)
order by substr(PPG_CODE, 2, 3), PPG_CODE;
*/