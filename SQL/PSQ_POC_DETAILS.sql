--
-- V_PSQ_POC_DETAILS_DATA
--
create or replace view V_PSQ_POC_DETAILS_DATA as
with Q_POC as
 (select ASR_YEAR, LOC_ID_RESIDENCE, LOC_ID_ORIGIN, POP_TYPE_CODE,
    max(REDACTION_LIMIT) as REDACTION_LIMIT, sum(VALUE) as VALUE
  from
   (select to_char(extract(year from STC.START_DATE)) as ASR_YEAR,
      STC.LOC_ID_ASYLUM_COUNTRY as LOC_ID_RESIDENCE,
      STC.LOC_ID_ORIGIN_COUNTRY as LOC_ID_ORIGIN,
      case DST.CODE || '/' || STC.STCT_CODE
        when 'ASY/ASYPOP' then 'AS'
        when 'ASY/ASYPOP-AH' then 'ASA'
        when 'IDP/IDPHPOP' then 'ID'
        when 'IDP/IDPHPOP-AH' then 'IDA'
        when 'IDP/IDPHRTN' then 'RD'
        when 'IDP/IDPHRTN-AH' then 'RDA'
        when 'IOC/IDPHPOP' then 'IL'
        when 'IOC/IDPHPOP-AH' then 'ILA'
        when 'IOC/IDPHRTN' then 'RD'
        when 'IOC/IDPHRTN-AH' then 'RDA'
        when 'OOC/OOCPOP' then 'OC'
        when 'OOC/OOCPOP-AH' then 'OCA'
        when 'REF/REFPOP' then 'RF'
        when 'REF/REFPOP-AH' then 'RFA'
        when 'ROC/REFPOP' then 'RL'
        when 'ROC/REFPOP-AH' then 'RLA'
        when 'STA/STAPOP' then 'ST'
        when 'STA/STAPOP-AH' then 'STA'
      end as POP_TYPE_CODE,
      STGA.REDACTION_LIMIT,
      STC.VALUE
    from T_STATISTICS STC
    inner join T_DISPLACEMENT_STATUSES DST
      on DST.ID = STC.DST_ID
    left outer join
     (select STIG.STC_ID, max(STGA.NUM_VALUE) REDACTION_LIMIT
      from T_STATISTICS_IN_GROUPS STIG
      inner join T_STC_GROUP_ATTRIBUTES STGA
        on STGA.STG_ID = STIG.STG_ID
        and STGA.STGAT_CODE = 'REDACTLMT'
      group by STIG.STC_ID) STGA
      on STGA.STC_ID = STC.ID
    where extract(day from STC.END_DATE) = 1
    and STC.STCT_CODE in
     ('REFPOP', 'REFPOP-AH', 'ASYPOP', 'ASYPOP-AH', 'IDPHPOP', 'IDPHPOP-AH',
      'IDPHRTN', 'IDPHRTN-AH', 'STAPOP', 'STAPOP-AH', 'OOCPOP', 'OOCPOP-AH')
    and nvl(STC.DIM_ID1, -1) !=
     (select ID
      from T_DIMENSION_VALUES
      where DIMT_CODE = 'OFFICIAL'
      and CODE = 'N'))
  group by ASR_YEAR, LOC_ID_RESIDENCE, LOC_ID_ORIGIN, POP_TYPE_CODE
  union all
  select ASR_YEAR, LOC_ID_RESIDENCE, LOC_ID_ORIGIN, POP_TYPE_CODE,
    REDACTION_LIMIT,
    greatest(nvl(VOLREP_VALUE, REFRTN_VALUE), nvl(REFRTN_VALUE, VOLREP_VALUE)) as VALUE
  from
   (select to_char(extract(year from STC.START_DATE)) as ASR_YEAR,
      STC.LOC_ID_ORIGIN_COUNTRY as LOC_ID_RESIDENCE,
      STC.LOC_ID_ASYLUM_COUNTRY as LOC_ID_ORIGIN,
      case when substr(STC.STCT_CODE, 7) = '-AH' then 'RTA' else 'RT' end as POP_TYPE_CODE,
      max(STGA.REDACTION_LIMIT) over (partition by extract(year from STC.START_DATE),
          STC.LOC_ID_ORIGIN_COUNTRY, STC.LOC_ID_ASYLUM_COUNTRY, substr(STC.STCT_CODE, 7))
        as REDACTION_LIMIT,
      substr(STC.STCT_CODE, 1, 6) as DATA_POINT,
      STC.VALUE
    from T_STATISTICS STC
    left outer join
     (select STIG.STC_ID, max(STGA.NUM_VALUE) REDACTION_LIMIT
      from T_STATISTICS_IN_GROUPS STIG
      inner join T_STC_GROUP_ATTRIBUTES STGA
        on STGA.STG_ID = STIG.STG_ID
        and STGA.STGAT_CODE = 'REDACTLMT'
      group by STIG.STC_ID) STGA
      on STGA.STC_ID = STC.ID
    where extract(day from STC.END_DATE) = 1
    and STC.STCT_CODE in
     ('VOLREP', 'VOLREP-AH', 'REFRTN', 'REFRTN-AH'))
  pivot
   (sum(VALUE) as VALUE
    for DATA_POINT
    in ('VOLREP' as VOLREP,
        'REFRTN' as REFRTN))),
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
select POC.ASR_YEAR,
  COU1.ITM_ID as ITM_ID_RESIDENCE,
  COU1.ISO3166_NUMERIC_CODE as COU_CODE_RESIDENCE,
  COU1.ISO3166_ALPHA3_CODE as ISO3166_ALPHA3_CODE_RESIDENCE,
  COU2.ITM_ID as ITM_ID_ORIGIN,
  nvl(COU2.ISO3166_NUMERIC_CODE, COU2.ISO3166_ALPHA3_CODE) as COU_CODE_ORIGIN,
  COU2.ISO3166_ALPHA3_CODE as ISO3166_ALPHA3_CODE_ORIGIN,
  POC.POP_TYPE_CODE,
  case when abs(POC.VALUE) >= nvl(POC.REDACTION_LIMIT, 0) then POC.VALUE end as VALUE,
  case when abs(POC.VALUE) < POC.REDACTION_LIMIT then 1 end as REDACTED_FLAG
from Q_POC POC
left outer join Q_COU COU1
  on COU1.LOC_ID = POC.LOC_ID_RESIDENCE
left outer join Q_COU COU2
  on COU2.LOC_ID = POC.LOC_ID_ORIGIN;

--
-- PSQ_POC_DETAILS_DATA
--
create materialized view PSQ_POC_DETAILS_DATA as
select ASR_YEAR,
  ITM_ID_RESIDENCE, COU_CODE_RESIDENCE, ISO3166_ALPHA3_CODE_RESIDENCE,
  ITM_ID_ORIGIN, COU_CODE_ORIGIN, ISO3166_ALPHA3_CODE_ORIGIN,
  POP_TYPE_CODE, VALUE, REDACTED_FLAG
from V_PSQ_POC_DETAILS_DATA;

create index IX_POCD_YEAR on PSQ_POC_DETAILS_DATA (ASR_YEAR);
create index IX_POCD_COU_RES on PSQ_POC_DETAILS_DATA (COU_CODE_RESIDENCE);
create index IX_POCD_COU_OGN on PSQ_POC_DETAILS_DATA (COU_CODE_ORIGIN);
create index IX_POCD_PTC on PSQ_POC_DETAILS_DATA (POP_TYPE_CODE);

--
-- PSQ_POC_DETAILS
--
create or replace view PSQ_POC_DETAILS as
select POC.ASR_YEAR,
  POC.COU_CODE_RESIDENCE, POC.ISO3166_ALPHA3_CODE_RESIDENCE,
  NAM1.NAME as COU_NAME_RESIDENCE,
  POC.COU_CODE_ORIGIN, POC.ISO3166_ALPHA3_CODE_ORIGIN,
  nvl(TXT.TEXT, NAM2.NAME) as COU_NAME_ORIGIN,
  POC.POP_TYPE_CODE, CDE.DESCRIPTION as POP_TYPE_DESCRIPTION, CDE.DISPLAY_SEQ as POP_TYPE_SEQ,
  POC.VALUE, POC.REDACTED_FLAG
from PSQ_POC_DETAILS_DATA POC
inner join NAMES NAM1
  on NAM1.ITM_ID = POC.ITM_ID_RESIDENCE
inner join NAMES NAM2
  on NAM2.ITM_ID = POC.ITM_ID_ORIGIN
left outer join T_TEXT_ITEMS TXT
  on TXT.ITM_ID = POC.ITM_ID_ORIGIN
  and TXT.TXTT_CODE = 'ORIGINNAME'
  and TXT.SEQ_NBR = 1
  and TXT.LANG_CODE = NAM2.LANG_CODE
left outer join
 (select CDE.CODE, DSC.DESCRIPTION, CDE.DISPLAY_SEQ
  from T_CODES CDE
  inner join DESCRIPTIONS DSC
    on DSC.ITM_ID = CDE.ITM_ID
  where CDE.CDET_CODE = 'POPTYPE') CDE
  on CDE.CODE = POC.POP_TYPE_CODE;

--
-- PSQ_POC_YEARS
--
create materialized view PSQ_POC_YEARS as
select distinct ASR_YEAR
from PSQ_POC_DETAILS_DATA;