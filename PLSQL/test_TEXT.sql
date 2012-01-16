-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when sqlcode = -20009 then 12 else 1 end))"

variable TXT_ID number
variable TXT_ID1 number
variable TXT_ID2 number
variable SEQ_NBR number
variable SEQ_NBR1 number
variable SEQ_NBR2 number

execute TEXT_TYPE.INSERT_TEXT_TYPE('INACT', 'en', 'Inactive', null, 'N');

set echo on serveroutput on feedback off recsepchar "."

column LONG_TEXT format A150

spool test_TEXT.log

-- Set text
-- ========

-- Success cases
-- -------------

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note 1'); :TXT_ID1 := :TXT_ID; &eh
execute :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note 2'); :SEQ_NBR1 := :SEQ_NBR; &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'es', rpad('x', 1001, unistr('\00F1'))); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'en', 'English description'); :TXT_ID2 := :TXT_ID; :SEQ_NBR2 := :SEQ_NBR; &eh
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := :SEQ_NBR1; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note 2a'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note 2b'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'es', 'Spanish note 3'); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', rpad('French note ', 1001, unistr('\8BF4'))); &eh
execute TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', rpad('French note ', 1001, '$')); &eh

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- cannot insert NULL into ("PSR"."TEXT_HEADERS"."TAB_ALIAS")
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Cannot specify a text item sequence number without a text identifier
execute :TXT_ID := null; :SEQ_NBR := 1; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- integrity constraint (PSR.FK_TXT_TAB) violated - parent key not found
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'XXXX', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text type
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'XXXX', :SEQ_NBR, 'en', 'English note'); &eh

-- Inactive text type
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'INACT', :SEQ_NBR, 'en', 'English note'); &eh

-- integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh

-- no data found
execute :TXT_ID := 9999999; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh

-- Wrong table for this text identifier
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text type
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'XXXX', :SEQ_NBR, 'en', 'English note'); &eh

-- Inactive text type
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'INACT', :SEQ_NBR, 'en', 'English note'); &eh

-- Only one text item of this type allowed
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'DESCR', :SEQ_NBR, 'en', 'English description'); &eh

-- No existing text of this type
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Text item sequence number greater than current maximum
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := 9; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text language
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'de', 'German note'); &eh

-- Inactive text language
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh

-- Text must be specified
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', ''); &eh

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Delete text
-- ===========

-- Error cases
-- -----------

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'de'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', 9999); &eh

-- no data found
execute TEXT.DELETE_TEXT(:TXT_ID1, 'XXXX'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(9999999); &eh

-- Cannot delete last mandatory text item
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2, 'en'); &eh

-- Cannot delete last mandatory text item
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2); &eh

-- Cannot delete mandatory text type
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', null, 'fr'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, null, :SEQ_NBR1, 'fr'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, null, null, 'fr'); &eh

-- no data found
execute TEXT.DELETE_TEXT(null, 'NOTE', :SEQ_NBR1, 'fr'); &eh

-- no data found
execute TEXT.DELETE_TEXT(null, 'NOTE', null, 'fr'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(null, null, :SEQ_NBR1, 'fr'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(null, null, null, 'fr'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, null, :SEQ_NBR1); &eh

-- no data found
execute TEXT.DELETE_TEXT(null, 'NOTE', :SEQ_NBR1); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(null, null, :SEQ_NBR1); &eh

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Success cases
-- -------------

execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'fr'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute :SEQ_NBR := null; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'en', 'English description'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID, 'NOTE'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID); &eh
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.SET_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'fr', 'French description'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2, 'en'); &eh

select TXT.ID, TXT.TAB_ALIAS,
  TTH.TXTT_CODE, TTH.TAB_ALIAS, TTH.TXI_SEQ_NBR_MAX,
  TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from TEXT_HEADERS TXT
join TEXT_TYPE_HEADERS TTH
  on TTH.TXT_ID = TXT.ID
join TEXT_ITEMS TXI
  on TXI.TXT_ID = TTH.TXT_ID
  and TXI.TXTT_CODE = TTH.TXTT_CODE
where TXT.ID >= :TXT_ID1
order by TXT.ID, TTH.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_TXT_ID

spool off
