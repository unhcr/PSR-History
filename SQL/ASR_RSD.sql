--
-- V_ASR_RSD_DATA
--
create or replace view V_ASR_RSD_DATA as
with Q_RSD as
 (select ASR_YEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY, DIM_ID1, DIM_ID2, REDACTION_LIMIT,
    ASYPOP_START_VALUE, ASYPOP_AH_START_VALUE,
    ASYAPP_VALUE, ASYREC_CV_VALUE, ASYREC_CP_VALUE, ASYREJ_VALUE, ASYOTHCL_VALUE,
    ASYPOP_END_VALUE, ASYPOP_AH_END_VALUE
  from
   (select extract(year from STC.START_DATE) as ASR_YEAR,
      STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ORIGIN_COUNTRY,
      STC.DIM_ID1, STC.DIM_ID2,
      max(STGA.REDACTION_LIMIT) over
       (partition by extract(year from STC.START_DATE),
          STC.LOC_ID_ASYLUM_COUNTRY, STC.LOC_ID_ORIGIN_COUNTRY, STC.DIM_ID1, STC.DIM_ID2)
        as REDACTION_LIMIT,
      replace(STC.STCT_CODE, '-', '_') ||
        case
          when extract(day from STC.END_DATE) = 2 then '_START'
          when extract(day from STC.START_DATE) = 31 then '_END'
        end as DATA_POINT,
      STC.VALUE
    from T_STATISTIC_TYPES_IN_GROUPS STTIG
    inner join T_STATISTICS STC
      on STC.STCT_CODE = STTIG.STCT_CODE
    left outer join
     (select STIG.STC_ID, max(STGA.NUM_VALUE) REDACTION_LIMIT
      from T_STATISTICS_IN_GROUPS STIG
      inner join T_STC_GROUP_ATTRIBUTES STGA
        on STGA.STG_ID = STIG.STG_ID
        and STGA.STGAT_CODE = 'REDACTLMT'
      group by STIG.STC_ID) STGA
      on STGA.STC_ID = STC.ID
    where STTIG.STTG_CODE = 'RSD')
  pivot
   (sum(VALUE) as VALUE
    for DATA_POINT
    in ('ASYPOP_START' as ASYPOP_START,
        'ASYPOP_AH_START' as ASYPOP_AH_START,
        'ASYAPP' as ASYAPP,
        'ASYREC_CV' as ASYREC_CV,
        'ASYREC_CP' as ASYREC_CP,
        'ASYREJ' as ASYREJ,
        'ASYOTHCL' as ASYOTHCL,
        'ASYPOP_END' as ASYPOP_END,
        'ASYPOP_AH_END' as ASYPOP_AH_END))),
--
Q_COU as
 (select LOC.ID as LOC_ID, LOC.ITM_ID,
    LOCA1.CHAR_VALUE as ISO3166_NUMERIC_CODE,
    LOCA2.CHAR_VALUE as ISO3166_ALPHA3_CODE
  from T_LOCATIONS LOC
  left outer join T_LOCATION_ATTRIBUTES LOCA1
    on LOCA1.LOC_ID = LOC.ID
    and LOCA1.LOCAT_CODE = 'ISO3166NUM'
  left outer join T_LOCATION_ATTRIBUTES LOCA2
    on LOCA2.LOC_ID = LOC.ID
    and LOCA2.LOCAT_CODE = 'ISO3166A3')
--
select RSD.ASR_YEAR,
  COU1.ITM_ID as ITM_ID_ASYLUM,
  COU1.ISO3166_NUMERIC_CODE as COU_CODE_ASYLUM,
  COU1.ISO3166_ALPHA3_CODE as ISO3166_ALPHA3_CODE_ASYLUM,
  COU2.ITM_ID as ITM_ID_ORIGIN,
  nvl(COU2.ISO3166_NUMERIC_CODE, COU2.ISO3166_ALPHA3_CODE) as COU_CODE_ORIGIN,
  COU2.ISO3166_ALPHA3_CODE as ISO3166_ALPHA3_CODE_ORIGIN,
  DIM1.ITM_ID as ITM_ID_RSD_PROC_TYPE, DIM1.CODE as RSD_PROC_TYPE_CODE,
  DIM2.ITM_ID as ITM_ID_RSD_PROC_LEVEL, DIM2.CODE as RSD_PROC_LEVEL_CODE,
  case
    when abs(RSD.ASYPOP_START_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYPOP_START_VALUE
  end as ASYPOP_START_VALUE,
  case
    when abs(RSD.ASYPOP_START_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYPOP_START_REDACTED_FLAG,
  case
    when abs(RSD.ASYPOP_AH_START_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYPOP_AH_START_VALUE
  end as ASYPOP_AH_START_VALUE,
  case
    when abs(RSD.ASYPOP_AH_START_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYPOP_AH_START_REDACTED_FLAG,
  case
    when abs(RSD.ASYAPP_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYAPP_VALUE
  end as ASYAPP_VALUE,
  case
    when abs(RSD.ASYAPP_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYAPP_REDACTED_FLAG,
  case
    when abs(RSD.ASYREC_CV_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYREC_CV_VALUE
  end as ASYREC_CV_VALUE,
  case
    when abs(RSD.ASYREC_CV_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYREC_CV_REDACTED_FLAG,
  case
    when abs(RSD.ASYREC_CP_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYREC_CP_VALUE
  end as ASYREC_CP_VALUE,
  case
    when abs(RSD.ASYREC_CP_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYREC_CP_REDACTED_FLAG,
  case
    when abs(RSD.ASYREJ_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYREJ_VALUE
  end as ASYREJ_VALUE,
  case
    when abs(RSD.ASYREJ_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYREJ_REDACTED_FLAG,
  case
    when abs(RSD.ASYOTHCL_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYOTHCL_VALUE
  end as ASYOTHCL_VALUE,
  case
    when abs(RSD.ASYOTHCL_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYOTHCL_REDACTED_FLAG,
  case
    when abs(RSD.ASYPOP_END_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYPOP_END_VALUE
  end as ASYPOP_END_VALUE,
  case
    when abs(RSD.ASYPOP_END_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYPOP_END_REDACTED_FLAG,
  case
    when abs(RSD.ASYPOP_AH_END_VALUE) >= nvl(RSD.REDACTION_LIMIT, 0) then RSD.ASYPOP_AH_END_VALUE
  end as ASYPOP_AH_END_VALUE,
  case
    when abs(RSD.ASYPOP_AH_END_VALUE) < RSD.REDACTION_LIMIT then 1
  end as ASYPOP_AH_END_REDACTED_FLAG
from Q_RSD RSD
inner join Q_COU COU1
  on COU1.LOC_ID = RSD.LOC_ID_ASYLUM_COUNTRY
left outer join Q_COU COU2
  on COU2.LOC_ID = RSD.LOC_ID_ORIGIN_COUNTRY
left outer join T_DIMENSION_VALUES DIM1
  on DIM1.ID = RSD.DIM_ID1
left outer join T_DIMENSION_VALUES DIM2
  on DIM2.ID = RSD.DIM_ID2;

--
-- ASR_RSD_DATA
--
create materialized view ASR_RSD_DATA as
select ASR_YEAR,
  ITM_ID_ASYLUM, COU_CODE_ASYLUM, ISO3166_ALPHA3_CODE_ASYLUM,
  ITM_ID_ORIGIN, COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN,
  ITM_ID_RSD_PROC_TYPE, RSD_PROC_TYPE_CODE, ITM_ID_RSD_PROC_LEVEL, RSD_PROC_LEVEL_CODE,
  ASYPOP_START_VALUE, ASYPOP_START_REDACTED_FLAG,
  ASYPOP_AH_START_VALUE, ASYPOP_AH_START_REDACTED_FLAG,
  ASYAPP_VALUE, ASYAPP_REDACTED_FLAG,
  ASYREC_CV_VALUE, ASYREC_CV_REDACTED_FLAG,
  ASYREC_CP_VALUE, ASYREC_CP_REDACTED_FLAG,
  ASYREJ_VALUE, ASYREJ_REDACTED_FLAG,
  ASYOTHCL_VALUE, ASYOTHCL_REDACTED_FLAG,
  ASYPOP_END_VALUE, ASYPOP_END_REDACTED_FLAG,
  ASYPOP_AH_END_VALUE, ASYPOP_AH_END_REDACTED_FLAG
from V_ASR_RSD_DATA;

create index IX_RSD_YEAR on ASR_RSD_DATA (ASR_YEAR);
create index IX_RSD_COU_ASY on ASR_RSD_DATA (COU_CODE_ASYLUM);
create index IX_RSD_COU_OGN on ASR_RSD_DATA (COU_CODE_ORIGIN);

--
-- ASR_RSD
--
create or replace view ASR_RSD as
select RSD.ASR_YEAR,
  RSD.COU_CODE_ASYLUM, RSD.ISO3166_ALPHA3_CODE_ASYLUM, NAM1.NAME as COU_NAME_ASYLUM,
  RSD.COU_CODE_ORIGIN, RSD.ISO3166_ALPHA3_CODE_ORIGIN, nvl(TXT.TEXT, NAM2.NAME) as COU_NAME_ORIGIN,
  RSD.RSD_PROC_TYPE_CODE, DSC1.DESCRIPTION as RSD_PROC_TYPE_DESCRIPTION,
  RSD.RSD_PROC_LEVEL_CODE, DSC2.DESCRIPTION as RSD_PROC_LEVEL_DESCRIPTION,
  RSD.ASYPOP_START_VALUE, RSD.ASYPOP_START_REDACTED_FLAG,
  RSD.ASYPOP_AH_START_VALUE, RSD.ASYPOP_AH_START_REDACTED_FLAG,
  RSD.ASYAPP_VALUE, RSD.ASYAPP_REDACTED_FLAG,
  RSD.ASYREC_CV_VALUE, RSD.ASYREC_CV_REDACTED_FLAG,
  RSD.ASYREC_CP_VALUE, RSD.ASYREC_CP_REDACTED_FLAG,
  RSD.ASYREJ_VALUE, RSD.ASYREJ_REDACTED_FLAG,
  RSD.ASYOTHCL_VALUE, RSD.ASYOTHCL_REDACTED_FLAG,
  RSD.ASYPOP_END_VALUE, RSD.ASYPOP_END_REDACTED_FLAG,
  RSD.ASYPOP_AH_END_VALUE, RSD.ASYPOP_AH_END_REDACTED_FLAG
from ASR_RSD_DATA RSD
inner join NAMES NAM1
  on NAM1.ITM_ID = RSD.ITM_ID_ASYLUM
left outer join NAMES NAM2
  on NAM2.ITM_ID = RSD.ITM_ID_ORIGIN
left outer join T_TEXT_ITEMS TXT
  on TXT.ITM_ID = RSD.ITM_ID_ORIGIN
  and TXT.TXTT_CODE = 'ORIGINNAME'
  and TXT.SEQ_NBR = 1
  and TXT.LANG_CODE = NAM2.LANG_CODE
left outer join DESCRIPTIONS DSC1
  on DSC1.ITM_ID = RSD.ITM_ID_RSD_PROC_TYPE
left outer join DESCRIPTIONS DSC2
  on DSC2.ITM_ID = RSD.ITM_ID_RSD_PROC_LEVEL;

--
-- ASR_RSD_EN
--
execute P_CONTEXT.SET_USERID('PUBLIC_ENGLISH');

create materialized view ASR_RSD_EN as
select ASR_YEAR,
  COU_CODE_ASYLUM, ISO3166_ALPHA3_CODE_ASYLUM, COU_NAME_ASYLUM,
  COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN, COU_NAME_ORIGIN,
  RSD_PROC_TYPE_CODE, RSD_PROC_TYPE_DESCRIPTION,
  RSD_PROC_LEVEL_CODE, RSD_PROC_LEVEL_DESCRIPTION,
  ASYPOP_START_VALUE, ASYPOP_START_REDACTED_FLAG,
  ASYPOP_AH_START_VALUE, ASYPOP_AH_START_REDACTED_FLAG,
  ASYAPP_VALUE, ASYAPP_REDACTED_FLAG,
  ASYREC_CV_VALUE, ASYREC_CV_REDACTED_FLAG,
  ASYREC_CP_VALUE, ASYREC_CP_REDACTED_FLAG,
  ASYREJ_VALUE, ASYREJ_REDACTED_FLAG,
  ASYOTHCL_VALUE, ASYOTHCL_REDACTED_FLAG,
  ASYPOP_END_VALUE, ASYPOP_END_REDACTED_FLAG,
  ASYPOP_AH_END_VALUE, ASYPOP_AH_END_REDACTED_FLAG
from ASR_RSD;

create index IX_RSDE_YEAR on ASR_RSD_EN (ASR_YEAR);
create index IX_RSDE_COU_ASY on ASR_RSD_EN (COU_CODE_ASYLUM);
create index IX_RSDE_COU_OGN on ASR_RSD_EN (COU_CODE_ORIGIN);

--
-- ASR_RSD_FR
--
execute P_CONTEXT.SET_USERID('PUBLIC_FRENCH');

create materialized view ASR_RSD_FR as
select ASR_YEAR,
  COU_CODE_ASYLUM, ISO3166_ALPHA3_CODE_ASYLUM, COU_NAME_ASYLUM,
  COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN, COU_NAME_ORIGIN,
  RSD_PROC_TYPE_CODE, RSD_PROC_TYPE_DESCRIPTION,
  RSD_PROC_LEVEL_CODE, RSD_PROC_LEVEL_DESCRIPTION,
  ASYPOP_START_VALUE, ASYPOP_START_REDACTED_FLAG,
  ASYPOP_AH_START_VALUE, ASYPOP_AH_START_REDACTED_FLAG,
  ASYAPP_VALUE, ASYAPP_REDACTED_FLAG,
  ASYREC_CV_VALUE, ASYREC_CV_REDACTED_FLAG,
  ASYREC_CP_VALUE, ASYREC_CP_REDACTED_FLAG,
  ASYREJ_VALUE, ASYREJ_REDACTED_FLAG,
  ASYOTHCL_VALUE, ASYOTHCL_REDACTED_FLAG,
  ASYPOP_END_VALUE, ASYPOP_END_REDACTED_FLAG,
  ASYPOP_AH_END_VALUE, ASYPOP_AH_END_REDACTED_FLAG
from ASR_RSD;

create index IX_RSDF_YEAR on ASR_RSD_FR (ASR_YEAR);
create index IX_RSDF_COU_ASY on ASR_RSD_FR (COU_CODE_ASYLUM);
create index IX_RSDF_COU_OGN on ASR_RSD_FR (COU_CODE_ORIGIN);