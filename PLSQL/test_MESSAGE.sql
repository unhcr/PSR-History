-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when sqlcode = -20009 then 12 else 1 end))"

set echo on serveroutput on feedback off recsepchar "."

column LONG_TEXT format A150

spool test_MESSAGE.log

-- Insert components
-- =================

-- Success cases
-- -------------

execute MESSAGE.INSERT_COMPONENT('TST1', 'en', 'Test 1'); &eh
execute MESSAGE.INSERT_COMPONENT('TST2', 'en', 'Test 2', null, 'N'); &eh
execute MESSAGE.INSERT_COMPONENT('TST3', 'en', 'Test 3', 1); &eh
execute MESSAGE.INSERT_COMPONENT('TST4', 'en', 'Test 4', 999, 'N'); &eh
execute MESSAGE.INSERT_COMPONENT('TST5', 'en', 'Test 5', pnDISPLAY_SEQ => 2); &eh
execute MESSAGE.INSERT_COMPONENT('TST6', 'en', 'Test 6', psACTIVE_FLAG => 'N'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE like 'TST%'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Text must be specified
execute MESSAGE.INSERT_COMPONENT('TST7', 'en', ''); &eh

-- Unknown text language
execute MESSAGE.INSERT_COMPONENT('TST7', 'xx', 'Statistic Types'); &eh

-- Inactive text language
execute MESSAGE.INSERT_COMPONENT('TST7', 'la', 'Statistic Types'); &eh

-- unique constraint (PSR.PK_COMP) violated
execute MESSAGE.INSERT_COMPONENT('TST1', 'en', 'Text'); &eh

-- value larger than specified precision allowed for this column
execute MESSAGE.INSERT_COMPONENT('TST7', 'en', 'Statistic Types', 1e6); &eh

-- check constraint (PSR.CH_COMP_ACTIVE_FLAG) violated
execute MESSAGE.INSERT_COMPONENT('TST7', 'en', 'Statistic Types', null, 'X'); &eh

-- Update components
-- =================

-- Success cases
-- -------------

execute MESSAGE.UPDATE_COMPONENT('TST1', 'en', 'Text!'); &eh
execute MESSAGE.UPDATE_COMPONENT('TST1', null, null, 1); &eh
execute MESSAGE.UPDATE_COMPONENT('TST1', null, null, null, 'N'); &eh
execute MESSAGE.UPDATE_COMPONENT('TST1', psLANG_CODE => 'en', psDescription => 'Text'); &eh
execute MESSAGE.UPDATE_COMPONENT('TST1', pnDISPLAY_SEQ => 2); &eh
execute MESSAGE.UPDATE_COMPONENT('TST1', psACTIVE_FLAG => 'Y'); &eh
execute MESSAGE.UPDATE_COMPONENT('TST1', pnDISPLAY_SEQ => null); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Description language cannot be specified without description text
execute MESSAGE.UPDATE_COMPONENT('TST1', 'en'); &eh

-- Unknown description language
execute MESSAGE.UPDATE_COMPONENT('TST1', 'xx', 'Text'); &eh

-- Inactive description language
execute MESSAGE.UPDATE_COMPONENT('TST1', 'la', 'Text'); &eh

-- no data found
execute MESSAGE.UPDATE_COMPONENT('XXX', 'en', 'Unknown'); &eh

-- Unknown description language
execute MESSAGE.UPDATE_COMPONENT('TST1', null, 'Text'); &eh

-- Nothing to be updated
execute MESSAGE.UPDATE_COMPONENT('TST1'); &eh

-- Component does not exist
execute MESSAGE.UPDATE_COMPONENT('XXX', pnDISPLAY_SEQ => 1); &eh

-- value larger than specified precision allowed for this column
execute MESSAGE.UPDATE_COMPONENT('TST1', pnDISPLAY_SEQ => 1e6); &eh

-- check constraint (PSR.CH_COMP_ACTIVE_FLAG) violated
execute MESSAGE.UPDATE_COMPONENT('TST1', psACTIVE_FLAG => 'X'); &eh

-- Set component descriptions
-- ==========================

-- Success cases
-- -------------

execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'fr', 'Text'); &eh
execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'fr', 'Texte'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown text language
execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'xx', 'Text'); &eh

-- Inactive text language
execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'la', 'Latin Text'); &eh

-- no data found
execute MESSAGE.SET_COMP_DESCRIPTION('XXX', 'en', 'Component'); &eh

-- Text must be specified
execute MESSAGE.SET_COMP_DESCRIPTION('TST1', 'ru', ''); &eh

-- Remove component descriptions
-- =============================

-- Error cases
-- -----------

-- no data found
execute MESSAGE.REMOVE_COMP_DESCRIPTION('XXX', 'fr'); &eh

-- Cannot delete last mandatory text item
execute MESSAGE.REMOVE_COMP_DESCRIPTION('TST2', 'en'); &eh

-- No text to delete
execute MESSAGE.REMOVE_COMP_DESCRIPTION('TST1', 'xx'); &eh

-- Success cases
-- -------------

execute MESSAGE.REMOVE_COMP_DESCRIPTION('TST1', 'fr'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Set component text
-- ==================

-- Success cases
-- -------------

variable SEQ_NBR number
execute MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown text language
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh

-- Inactive text language
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh

-- no data found
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Unknown text type
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh

-- Only one text item of this type allowed
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh

-- No existing text of this type
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST2', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Text item sequence number greater than current maximum
execute :SEQ_NBR := 9; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Text must be specified
execute :SEQ_NBR := null; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'en', ''); &eh

-- no data found
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh

-- Unknown text type
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh

-- Text item sequence number greater than current maximum
execute :SEQ_NBR := 9; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh

-- Unknown text language
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh

-- Text must be specified
execute :SEQ_NBR := 1; MESSAGE.SET_COMP_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', ''); &eh

-- Remove component text
-- =====================

-- Error cases
-- -----------

-- no data found
execute MESSAGE.REMOVE_COMP_TEXT('XXX', 'NOTE', 1, 'en'); &eh

-- Text type must be specified
execute MESSAGE.REMOVE_COMP_TEXT('TST1', null); &eh

-- no data found
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'XXXX', 1, 'en'); &eh

-- No text to delete
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 9, 'en'); &eh

-- No text to delete
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 1, 'xx'); &eh

-- No text to delete
execute MESSAGE.REMOVE_COMP_TEXT('TST2', 'NOTE'); &eh

-- Cannot delete mandatory text type
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'DESCR'); &eh

-- Cannot delete last mandatory text item
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'DESCR', 1); &eh

-- Cannot delete last mandatory text item
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'DESCR', 1, 'en'); &eh

-- Success cases
-- -------------

execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 1, 'en'); &eh
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE', 1); &eh
execute MESSAGE.REMOVE_COMP_TEXT('TST1', 'NOTE'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE = 'TST1'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Delete components
-- =================

-- Error cases
-- -----------

-- Component does not exist
execute MESSAGE.DELETE_COMPONENT('XXX'); &eh

-- Success cases
-- -------------

execute MESSAGE.DELETE_COMPONENT('TST6'); &eh

select COMP.CODE, COMP.DISPLAY_SEQ, COMP.ACTIVE_FLAG, COMP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from COMPONENTS COMP
join TEXT_ITEMS TXI
  on TXI.TXT_ID = COMP.TXT_ID
where COMP.CODE like 'TST%'
order by COMP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/


-- Insert messages
-- ===============

-- Success cases
-- -------------

variable SEQ_NBR number;
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message'); &eh
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Warning message', 'W'); &eh
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST2', :SEQ_NBR, 'fr', unistr('Message fran\00E7ais'), psSEVERITY => 'I'); &eh
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message 2'); &eh
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', rpad('Error message 3 ', 1001, 'x')); &eh
execute MESSAGE.DELETE_MESSAGE('TST1', 2); &eh
execute :SEQ_NBR := 2; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message 2a'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Text must be specified
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', ''); &eh

-- Unknown text language
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'xx', 'Message'); &eh

-- Inactive text language
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'la', 'Latin message'); &eh

-- unique constraint (PSR.PK_MSG) violated
execute :SEQ_NBR := 1; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message', 'W'); &eh

-- Component does not exist
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('XXX', :SEQ_NBR, 'en', 'Error message'); &eh

-- no data found
execute :SEQ_NBR := 1; MESSAGE.INSERT_MESSAGE('XXX', :SEQ_NBR, 'en', 'Error message'); &eh

-- Message sequence number greater than current maximum
execute :SEQ_NBR := 9; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message'); &eh

-- unique constraint (PSR.PK_MSG) violated
execute :SEQ_NBR := 1; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message'); &eh

-- check constraint (PSR.CH_MSG_SEVERITY) violated
execute :SEQ_NBR := null; MESSAGE.INSERT_MESSAGE('TST1', :SEQ_NBR, 'en', 'Error message', 'X'); &eh

-- Update messages
-- ===============

-- Success cases
-- -------------

execute MESSAGE.UPDATE_MESSAGE('TST1', 1, 'en', 'Error message!'); &eh
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, null, null, 'I'); &eh
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, psLANG_CODE => 'en', psMessage => 'Error message'); &eh
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, psSEVERITY => 'E'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown message language
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, null, 'Error message'); &eh

-- Unknown message language
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, 'xx', 'Error message'); &eh

-- Inactive message language
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, 'la', 'Error message'); &eh

-- no data found
execute MESSAGE.UPDATE_MESSAGE('XXX', 1, 'en', 'Error message'); &eh

-- no data found
execute MESSAGE.UPDATE_MESSAGE('TST1', 9, 'en', 'Error message'); &eh

-- Text item does not exist
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, 'ru', 'Error message'); &eh

-- Message language cannot be specified without message text
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, 'en'); &eh

-- Nothing to be updated
execute MESSAGE.UPDATE_MESSAGE('TST1', 1); &eh

-- Message does not exist
execute MESSAGE.UPDATE_MESSAGE('TST4', 1, psSEVERITY => 'E'); &eh

-- Message does not exist
execute MESSAGE.UPDATE_MESSAGE('TST1', 9, psSEVERITY => 'E'); &eh

-- check constraint (PSR.CH_MSG_SEVERITY) violated
execute MESSAGE.UPDATE_MESSAGE('TST1', 1, psSEVERITY => 'X'); &eh

-- Set message variants
-- ====================

-- Success cases
-- -------------

execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'fr', unistr('Message fran\00E7ais')); &eh
execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'fr', unistr('Error message fran\00E7ais')); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown text language
execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'xx', 'Error message'); &eh

-- Inactive text language
execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'la', 'Latin error message'); &eh

-- no data found
execute MESSAGE.SET_MSG_MESSAGE('XXX', 1, 'en', 'Error message'); &eh

-- no data found
execute MESSAGE.SET_MSG_MESSAGE('TST1', 9, 'en', 'Error message'); &eh

-- Text must be specified
execute MESSAGE.SET_MSG_MESSAGE('TST1', 1, 'ru', ''); &eh

-- Remove message variants
-- =======================

-- Error cases
-- -----------

-- no data found
execute MESSAGE.REMOVE_MSG_MESSAGE('XXX', 1, 'fr'); &eh

-- no data found
execute MESSAGE.REMOVE_MSG_MESSAGE('TST1', 9, 'fr'); &eh

-- Cannot delete last mandatory text item
execute MESSAGE.REMOVE_MSG_MESSAGE('TST2', 1, 'fr'); &eh

-- No text to delete
execute MESSAGE.REMOVE_MSG_MESSAGE('TST2', 1, 'en'); &eh

-- Success cases
-- -------------

execute MESSAGE.REMOVE_MSG_MESSAGE('TST1', 1, 'fr'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Set message general text
-- ========================

-- Success cases
-- -------------

variable TXI_SEQ_NBR number
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'en', 'English note'); &eh
execute MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :TXI_SEQ_NBR := 2; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :TXI_SEQ_NBR := 2; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Error cases
-- -----------

-- Unknown text language
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'xx', 'Unknown note'); &eh

-- Inactive text language
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'la', 'Latin note'); &eh

-- no data found
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('XXX', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh

-- no data found
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 9, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh

-- Unknown text type
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'XXXX', :TXI_SEQ_NBR, 'fr', 'French note'); &eh

-- Only one text item of this type allowed
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'MSG', :TXI_SEQ_NBR, 'fr', 'French note'); &eh

-- No existing text of this type
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST2', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh

-- Text item sequence number greater than current maximum
execute :TXI_SEQ_NBR := 9; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'French note'); &eh

-- Text must be specified
execute :TXI_SEQ_NBR := null; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'en', ''); &eh

-- no data found
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('XXX', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh

-- no data found
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 9, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh

-- Unknown text type
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'XXXX', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh

-- Text item sequence number greater than current maximum
execute :TXI_SEQ_NBR := 9; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', 'Updated note'); &eh

-- Unknown text language
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'xx', 'Updated note'); &eh

-- Text must be specified
execute :TXI_SEQ_NBR := 1; MESSAGE.SET_MSG_TEXT('TST1', 1, 'NOTE', :TXI_SEQ_NBR, 'fr', ''); &eh

-- Remove message general text
-- ===========================

-- Error cases
-- -----------

-- no data found
execute MESSAGE.REMOVE_MSG_TEXT('XXX', 1, 'NOTE', 1, 'en'); &eh

-- no data found
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 9, 'NOTE', 1, 'en'); &eh

-- Text type must be specified
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, null); &eh

-- no data found
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'XXXX', 1, 'en'); &eh

-- No text to delete
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 9, 'en'); &eh

-- No text to delete
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 1, 'xx'); &eh

-- No text to delete
execute MESSAGE.REMOVE_MSG_TEXT('TST2', 1, 'NOTE'); &eh

-- Cannot delete mandatory text type
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'MSG'); &eh

-- Cannot delete last mandatory text item
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'MSG', 1); &eh

-- Cannot delete last mandatory text item
execute MESSAGE.REMOVE_MSG_TEXT('TST2', 1, 'MSG', 1, 'fr'); &eh

-- Success cases
-- -------------

execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 1, 'en'); &eh
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE', 1); &eh
execute MESSAGE.REMOVE_MSG_TEXT('TST1', 1, 'NOTE'); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Delete messages
-- ===============

-- Error cases
-- -----------

-- Message does not exist
execute MESSAGE.DELETE_MESSAGE('XXX', 1); &eh

-- Message does not exist
execute MESSAGE.DELETE_MESSAGE('TST1', 9); &eh

-- Success cases
-- -------------

execute MESSAGE.DELETE_MESSAGE('TST1', 1); &eh

select MSG.COMP_CODE, MSG.SEQ_NBR, MSG.SEVERITY, MSG.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from MESSAGES MSG
join TEXT_ITEMS TXI
  on TXI.TXT_ID = MSG.TXT_ID
where MSG.COMP_CODE like 'TST%'
order by MSG.COMP_CODE, MSG.SEQ_NBR, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE
/

-- Display messages
-- ================

-- Success cases
-- -------------

execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'en'); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST1', 3, 'en', 'Error message 2'); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST1', 4, 'en', rpad('Error message 3 ', 1001, 'x'), 'W'); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'en', psSEVERITY => 'I'); &eh
execute MESSAGE.DISPLAY_MESSAGE('TST2', 1, 'fr'); &eh

-- Error cases
-- -----------

-- ** Message not found **
execute MESSAGE.DISPLAY_MESSAGE('XXX', 1, 'en'); &eh

-- ** Message not found **
execute MESSAGE.DISPLAY_MESSAGE('TST1', 9, 'en', 'Dummy message'); &eh

-- ** Invalid severity **
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'en', psSEVERITY => 'X'); &eh

-- ** No stored English message **
execute MESSAGE.DISPLAY_MESSAGE('TST2', 1, 'fr', 'French message'); &eh

-- ** English message mismatch **
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'en', 'Error message'); &eh

-- ** No preferred language message **
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'fr'); &eh

-- ** No preferred language message ** ** No message found **
execute MESSAGE.DISPLAY_MESSAGE('TST2', 1, 'en'); &eh

-- ** No preferred language message ** ** No stored English message **
execute MESSAGE.DISPLAY_MESSAGE('TST2', 1, 'en', 'Error message'); &eh

-- ** No preferred language message ** ** English message mismatch **
execute MESSAGE.DISPLAY_MESSAGE('TST1', 2, 'fr', 'Error message'); &eh

set echo off serveroutput off feedback on

@check_orphan_TXT_ID

spool off
