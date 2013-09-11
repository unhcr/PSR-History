create or replace view UNHCR_REGION_TREE as
with Q_LOC (ID, CODE, NAME, SORT_SEQ, SORT_NAME, LOCT_CODE, TREE_LEVEL) as
 (select LOC.ID,
    LOCA1.CHAR_VALUE as CODE,
    nvl(TXT1.TEXT, NAM.NAME) as NAME,
    LOCA2.NUM_VALUE as SORT_SEQ,
    nlssort(nvl(TXT2.TEXT, NAM.NAME), 'NLS_SORT=BINARY_AI') as SORT_NAME,
    LOC.LOCT_CODE,
    1 as TREE_LEVEL
  from T_LOCATIONS LOC
  inner join NAMES NAM
    on NAM.ITM_ID = LOC.ITM_ID
  left outer join TEXT_ITEMS TXT1
    on TXT1.ITM_ID = LOC.ITM_ID
    and TXT1.TXTT_CODE = 'PSRNAME'
    and TXT1.SEQ_NBR = 1
    and TXT1.LANG_CODE = NAM.LANG_CODE
  left outer join TEXT_ITEMS TXT2
    on TXT2.ITM_ID = LOC.ITM_ID
    and TXT2.TXTT_CODE = 'SORTNAME'
    and TXT2.SEQ_NBR = 1
    and TXT2.LANG_CODE = NAM.LANG_CODE
  inner join T_LOCATION_ATTRIBUTES LOCA1
    on LOCA1.LOC_ID = LOC.ID
    and LOCA1.LOCAT_CODE = 'HCRCD'
  left outer join T_LOCATION_ATTRIBUTES LOCA2
    on LOCA2.LOC_ID = LOC.ID
    and LOCA2.LOCAT_CODE = 'DISPLAYSEQ'
  where LOC.LOCT_CODE = 'UNHCR'
  and LOC.START_DATE <= sysdate
  and LOC.END_DATE > sysdate
  union all
  select LOC2.ID,
    LOCA1.CHAR_VALUE as CODE,
    nvl(TXT1.TEXT, NAM.NAME) as NAME,
    LOCA2.NUM_VALUE as SORT_SEQ,
    nlssort(nvl(TXT2.TEXT, NAM.NAME), 'NLS_SORT=BINARY_AI') as SORT_NAME,
    LOC2.LOCT_CODE,
    LOC1.TREE_LEVEL + 1 as TREE_LEVEL
  from Q_LOC LOC1
  inner join T_LOCATION_RELATIONSHIPS LOCR
    on LOCR.LOC_ID_FROM = LOC1.ID
    and LOCR.LOCRT_CODE = 'HCRRESP'
  inner join T_LOCATIONS LOC2
    on LOC2.ID = LOCR.LOC_ID_TO
    and LOC2.LOCT_CODE in ('HCR-BUR', 'HCR-ROP')
    and LOC2.START_DATE <= sysdate
    and LOC2.END_DATE > sysdate
  inner join NAMES NAM
    on NAM.ITM_ID = LOC2.ITM_ID
  left outer join TEXT_ITEMS TXT1
    on TXT1.ITM_ID = LOC2.ITM_ID
    and TXT1.TXTT_CODE = 'PSRNAME'
    and TXT1.SEQ_NBR = 1
    and TXT1.LANG_CODE = NAM.LANG_CODE
  left outer join TEXT_ITEMS TXT2
    on TXT2.ITM_ID = LOC2.ITM_ID
    and TXT2.TXTT_CODE = 'SORTNAME'
    and TXT2.SEQ_NBR = 1
    and TXT2.LANG_CODE = NAM.LANG_CODE
  inner join T_LOCATION_ATTRIBUTES LOCA1
    on LOCA1.LOC_ID = LOC2.ID
    and LOCA1.LOCAT_CODE = 'HCRCD'
  left outer join T_LOCATION_ATTRIBUTES LOCA2
    on LOCA2.LOC_ID = LOC2.ID
    and LOCA2.LOCAT_CODE = 'DISPLAYSEQ')
  search depth first by SORT_SEQ, SORT_NAME set ORDER_SEQ
--
select ID, CODE, NAME, LOCT_CODE, TREE_LEVEL, ORDER_SEQ
from Q_LOC;