-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when sqlcode = -20009 then 12 else 1 end))"

set echo on serveroutput on feedback off recsepchar "."

column LONG_TEXT format A150

spool test_LANGUAGE.log

-- Set languages
-- =============

-- Success cases
-- -------------

execute LANGUAGE.SET_LANGUAGE('de', 'en', 'German'); &eh
execute LANGUAGE.SET_LANGUAGE('eo', 'en', 'Esperanto', null, 'N'); &eh
execute LANGUAGE.SET_LANGUAGE('it', 'en', 'Italian', 1); &eh
execute LANGUAGE.SET_LANGUAGE('enm', 'en', 'Middle English', 999, 'N'); &eh
execute LANGUAGE.SET_LANGUAGE('nl', 'en', 'Dutch', pnDISPLAY_SEQ => 2); &eh
execute LANGUAGE.SET_LANGUAGE('frm', 'en', 'Middle French', psACTIVE_FLAG => 'N'); &eh
execute LANGUAGE.SET_LANGUAGE('de', 'en', 'German!'); &eh
execute LANGUAGE.SET_LANGUAGE('de', null, null, 1); &eh
execute LANGUAGE.SET_LANGUAGE('de', null, null, null, 'N'); &eh
execute LANGUAGE.SET_LANGUAGE('de', psLANG_CODE => 'en', psDescription => 'German'); &eh
execute LANGUAGE.SET_LANGUAGE('de', pnDISPLAY_SEQ => 2); &eh
execute LANGUAGE.SET_LANGUAGE('de', psACTIVE_FLAG => 'Y'); &eh
execute LANGUAGE.SET_LANGUAGE('de', pnDISPLAY_SEQ => null); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE in ('de', 'eo', 'it', 'enm', 'nl', 'frm')
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Description must be specified for new language
execute LANGUAGE.SET_LANGUAGE('gr', 'en', ''); &eh

-- Unknown description language
execute LANGUAGE.SET_LANGUAGE('gr', 'xx', 'German'); &eh

-- Inactive description language
execute LANGUAGE.SET_LANGUAGE('gr', 'la', 'German'); &eh

-- value larger than specified precision allowed for this column
execute LANGUAGE.SET_LANGUAGE('gr', 'en', 'Greek', 1e6); &eh

-- check constraint (PSR.CH_LANG_ACTIVE_FLAG) violated
execute LANGUAGE.SET_LANGUAGE('gr', 'en', 'Greek', null, 'X'); &eh

-- value too large for column "PSR"."LANGUAGES"."ACTIVE_FLAG" (actual: 2, maximum: 1)
execute LANGUAGE.SET_LANGUAGE('gr', 'en', 'Greek', null, 'YY'); &eh

-- Description language cannot be specified without description text
execute LANGUAGE.SET_LANGUAGE('de', 'en'); &eh

-- Unknown description language
execute LANGUAGE.SET_LANGUAGE('de', 'xx', 'German'); &eh

-- Inactive description language
execute LANGUAGE.SET_LANGUAGE('de', 'la', 'German'); &eh

-- Unknown description language
execute LANGUAGE.SET_LANGUAGE('de', null, 'German'); &eh

-- Nothing to be updated
execute LANGUAGE.SET_LANGUAGE('de'); &eh

-- value larger than specified precision allowed for this column
execute LANGUAGE.SET_LANGUAGE('de', pnDISPLAY_SEQ => 1e6); &eh

-- check constraint (PSR.CH_LANG_ACTIVE_FLAG) violated
execute LANGUAGE.SET_LANGUAGE('de', psACTIVE_FLAG => 'X'); &eh

-- value too large for column "PSR"."LANGUAGES"."ACTIVE_FLAG" (actual: 2, maximum: 1)
execute LANGUAGE.SET_LANGUAGE('de', psACTIVE_FLAG => 'YY'); &eh

-- Set language descriptions
-- =========================

-- Success cases
-- -------------

execute LANGUAGE.SET_LANG_DESCRIPTION('de', 'fr', 'German'); &eh
execute LANGUAGE.SET_LANG_DESCRIPTION('de', 'fr', 'Allemand'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown text language
execute LANGUAGE.SET_LANG_DESCRIPTION('de', 'xx', 'German'); &eh

-- Inactive text language
execute LANGUAGE.SET_LANG_DESCRIPTION('de', 'la', 'Latin German'); &eh

-- no data found
execute LANGUAGE.SET_LANG_DESCRIPTION('xx', 'en', 'Language'); &eh

-- Text must be specified
execute LANGUAGE.SET_LANG_DESCRIPTION('de', 'ru', ''); &eh

-- Remove language descriptions
-- ============================

-- Error cases
-- -----------

-- no data found
execute LANGUAGE.REMOVE_LANG_DESCRIPTION('xx', 'fr'); &eh

-- Cannot delete last mandatory text item
execute LANGUAGE.REMOVE_LANG_DESCRIPTION('it', 'en'); &eh

-- No text to delete
execute LANGUAGE.REMOVE_LANG_DESCRIPTION('de', 'xx'); &eh

-- Success cases
-- -------------

execute LANGUAGE.REMOVE_LANG_DESCRIPTION('de', 'fr'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Set language text
-- =================

-- Success cases
-- -------------

variable SEQ_NBR number
execute LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown text language
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh

-- Inactive text language
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh

-- no data found
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('xx', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Unknown text type
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh

-- Only one text item of this type allowed
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh

-- No existing text of this type
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('it', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Text item sequence number greater than current maximum
execute :SEQ_NBR := 9; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Text must be specified
execute :SEQ_NBR := null; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'en', ''); &eh

-- no data found
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('xx', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh

-- Unknown text type
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh

-- Text item sequence number greater than current maximum
execute :SEQ_NBR := 9; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh

-- Unknown text language
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh

-- Text must be specified
execute :SEQ_NBR := 1; LANGUAGE.SET_LANG_TEXT('de', 'NOTE', :SEQ_NBR, 'fr', ''); &eh

-- Remove language text
-- ====================

-- Error cases
-- -----------

-- no data found
execute LANGUAGE.REMOVE_LANG_TEXT('xx', 'NOTE', 1, 'en'); &eh

-- Text type must be specified
execute LANGUAGE.REMOVE_LANG_TEXT('de', null); &eh

-- no data found
execute LANGUAGE.REMOVE_LANG_TEXT('de', 'XXXX', 1, 'en'); &eh

-- No text to delete
execute LANGUAGE.REMOVE_LANG_TEXT('de', 'NOTE', 9, 'en'); &eh

-- No text to delete
execute LANGUAGE.REMOVE_LANG_TEXT('de', 'NOTE', 1, 'xx'); &eh

-- No text to delete
execute LANGUAGE.REMOVE_LANG_TEXT('it', 'NOTE'); &eh

-- Cannot delete mandatory text type
execute LANGUAGE.REMOVE_LANG_TEXT('en', 'DESCR'); &eh

-- Cannot delete last mandatory text item
execute LANGUAGE.REMOVE_LANG_TEXT('fr', 'DESCR', 1); &eh

-- Cannot delete last mandatory text item
execute LANGUAGE.REMOVE_LANG_TEXT('it', 'DESCR', 1, 'en'); &eh

-- Success cases
-- -------------

execute LANGUAGE.REMOVE_LANG_TEXT('de', 'NOTE', 1, 'en'); &eh
execute LANGUAGE.REMOVE_LANG_TEXT('de', 'NOTE', 1); &eh
execute LANGUAGE.REMOVE_LANG_TEXT('de', 'NOTE'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE = 'de'
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Delete languages
-- ================

-- Error cases
-- -----------

-- integrity constraint (PSR.FK_TXI_LANG) violated - child record found
execute LANGUAGE.DELETE_LANGUAGE('en'); &eh

-- Language does not exist
execute LANGUAGE.DELETE_LANGUAGE('xx'); &eh

-- Success cases
-- -------------

execute LANGUAGE.DELETE_LANGUAGE('frm'); &eh

select LANG.CODE, LANG.DISPLAY_SEQ, LANG.ACTIVE_FLAG, LANG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from LANGUAGES LANG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = LANG.TXT_ID
where LANG.CODE in ('de', 'eo', 'it', 'enm', 'nl', 'frm')
order by LANG.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_TXT_ID

spool off
