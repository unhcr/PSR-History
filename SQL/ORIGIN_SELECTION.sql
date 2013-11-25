create or replace view ORIGIN_SELECTION as
with Q_LOC (ID, CODE, NAME, LOCT_CODE, SORT_NAME, LOC_ID_FROM) as
 (select LOC.ID,
    nvl(LOCA1.CHAR_VALUE, LOCA2.CHAR_VALUE) as CODE,
    coalesce(TXT1.TEXT, TXT2.TEXT, NAM.NAME) as NAME,
    LOC.LOCT_CODE,
    nvl(TXT3.TEXT, NAM.NAME) as SORT_NAME,
    LOCR.LOC_ID_FROM
  from T_LOCATIONS LOC
  inner join NAMES NAM
    on NAM.ITM_ID = LOC.ITM_ID
  left outer join T_TEXT_ITEMS TXT1
    on TXT1.ITM_ID = LOC.ITM_ID
    and TXT1.TXTT_CODE = 'ORIGINNAME'
    and TXT1.SEQ_NBR = 1
    and TXT1.LANG_CODE = NAM.LANG_CODE
  left outer join T_TEXT_ITEMS TXT2
    on TXT2.ITM_ID = LOC.ITM_ID
    and TXT2.TXTT_CODE = 'PSRNAME'
    and TXT2.SEQ_NBR = 1
    and TXT2.LANG_CODE = NAM.LANG_CODE
  left outer join T_TEXT_ITEMS TXT3
    on TXT3.ITM_ID = LOC.ITM_ID
    and TXT3.TXTT_CODE = 'SORTNAME'
    and TXT3.SEQ_NBR = 1
    and TXT3.LANG_CODE = NAM.LANG_CODE
  left outer join T_LOCATION_ATTRIBUTES LOCA1
    on LOCA1.LOC_ID = LOC.ID
    and LOCA1.LOCAT_CODE = 'ISO3166NUM'
  inner join T_LOCATION_ATTRIBUTES LOCA2
    on LOCA2.LOC_ID = LOC.ID
    and LOCA2.LOCAT_CODE = 'ISO3166A3'
  left outer join T_LOCATION_RELATIONSHIPS LOCR
    on LOCR.LOC_ID_TO = LOC.ID
    and LOCR.LOCRT_CODE = 'CCHANGE'
  where LOC.LOCT_CODE in ('COUNTRY', 'OTHORIGIN')
  and not exists
   (select null
    from T_LOCATION_RELATIONSHIPS LOCR1
    where LOCR1.LOC_ID_FROM = LOC.ID
    and LOCR1.LOCRT_CODE = 'CCHANGE')
  union all
  select LOC1.ID,
    LOC1.CODE,
    LOC1.NAME ||
    case
      when coalesce(TXT1.TEXT, TXT2.TEXT, NAM.NAME) != LOC1.NAME
      then ' / ' || coalesce(TXT1.TEXT, TXT2.TEXT, NAM.NAME)
    end as NAME,
    LOC2.LOCT_CODE,
    LOC1.SORT_NAME,
    LOCR.LOC_ID_FROM
  from Q_LOC LOC1
  inner join T_LOCATIONS LOC2
    on LOC2.ID = LOC1.LOC_ID_FROM
    and LOC2.LOCT_CODE in ('COUNTRY', 'OTHORIGIN')
  inner join NAMES NAM
    on NAM.ITM_ID = LOC2.ITM_ID
  left outer join T_TEXT_ITEMS TXT1
    on TXT1.ITM_ID = LOC2.ITM_ID
    and TXT1.TXTT_CODE = 'ORIGINNAME'
    and TXT1.SEQ_NBR = 1
    and TXT1.LANG_CODE = NAM.LANG_CODE
  left outer join T_TEXT_ITEMS TXT2
    on TXT2.ITM_ID = LOC2.ITM_ID
    and TXT2.TXTT_CODE = 'PSRNAME'
    and TXT2.SEQ_NBR = 1
    and TXT2.LANG_CODE = NAM.LANG_CODE
  left outer join T_LOCATION_RELATIONSHIPS LOCR
    on LOCR.LOC_ID_TO = LOC2.ID
    and LOCR.LOCRT_CODE = 'CCHANGE')
--
select ID, CODE, NAME, LOCT_CODE, nlssort(SORT_NAME, 'NLS_SORT=BINARY_AI') as SORT_NAME
from Q_LOC
where LOC_ID_FROM is null;