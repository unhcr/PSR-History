--
-- ASR_POC_SUMMARY
--
create materialized view ASR_POC_SUMMARY as
with Q_POC_SUMMARY as
 (select ASR_YEAR, LOC_ID_ASYLUM_COUNTRY, LOC_ID_ORIGIN_COUNTRY,
    REFPOP_VALUE, ASYPOP_VALUE,
    greatest(nvl(VOLREP_VALUE, REFRTN_VALUE), nvl(REFRTN_VALUE, VOLREP_VALUE)) as REFRTN_VALUE,
    IDPHPOP_VALUE, IDPHRTN_VALUE, STAPOP_VALUE, OOCPOP_VALUE
  from
   (select to_char(extract(year from STC.START_DATE)) as ASR_YEAR,
      case
        when STC.STCT_CODE in ('VOLREP', 'REFRTN') then STC.LOC_ID_ORIGIN_COUNTRY
        else STC.LOC_ID_ASYLUM_COUNTRY
      end as LOC_ID_ASYLUM_COUNTRY,
      case
        when STC.STCT_CODE in ('VOLREP', 'REFRTN') then STC.LOC_ID_ASYLUM_COUNTRY
        else STC.LOC_ID_ORIGIN_COUNTRY
      end as LOC_ID_ORIGIN_COUNTRY,
      STC.STCT_CODE,
      VALUE
    from T_STATISTICS STC
    where extract(day from STC.END_DATE) = 1
    and STC.STCT_CODE in
     ('REFPOP', 'ASYPOP', 'VOLREP', 'REFRTN', 'IDPHPOP', 'IDPHRTN', 'STAPOP', 'OOCPOP')
    and nvl(STC.DIM_ID1, -1) !=
     (select ID
      from T_DIMENSION_VALUES
      where DIMT_CODE = 'OFFICIAL'
      and CODE = 'N'))
  pivot
   (sum(VALUE) as VALUE
    for STCT_CODE
    in ('REFPOP' as REFPOP,
        'ASYPOP' as ASYPOP,
        'VOLREP' as VOLREP,
        'REFRTN' as REFRTN,
        'IDPHPOP' as IDPHPOP,
        'IDPHRTN' as IDPHRTN,
        'STAPOP' as STAPOP,
        'OOCPOP' as OOCPOP))),
--
Q_LOCATIONS as
 (select ID, NAME
  from
   (select LOC.ID, TXT.TEXT as NAME,
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
  where RANK = 1)
--
select SUM.ASR_YEAR,
  SUM.LOC_ID_ASYLUM_COUNTRY, LOC1.NAME as LOC_NAME_ASYLUM_COUNTRY,
  SUM.LOC_ID_ORIGIN_COUNTRY, LOC2.NAME LOC_NAME_ORIGIN_COUNTRY,
  REFPOP_VALUE, ASYPOP_VALUE, REFRTN_VALUE, IDPHPOP_VALUE, IDPHRTN_VALUE, STAPOP_VALUE, OOCPOP_VALUE
from Q_POC_SUMMARY SUM
inner join Q_LOCATIONS LOC1
  on LOC1.ID = SUM.LOC_ID_ASYLUM_COUNTRY
inner join Q_LOCATIONS LOC2
  on LOC2.ID = SUM.LOC_ID_ORIGIN_COUNTRY;