-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when sqlcode = -20009 then 12 else 1 end))"

set echo on serveroutput on feedback off

spool test_TEXT_TYPE.log

-- Insert text types
-- =================

-- Success cases
-- -------------

execute TEXT_TYPE.INSERT_TEXT_TYPE('TST1', 'en', 'Test 1'); &eh
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST2', 'en', 'Test 2', null, 'N'); &eh
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST3', 'en', 'Test 3', 1); &eh
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST4', 'en', 'Test 4', 999, 'N'); &eh
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST5', 'en', 'Test 5', pnDISPLAY_SEQ => 2); &eh
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST6', 'en', 'Test 6', psACTIVE_FLAG => 'N'); &eh

-- Error cases
-- -----------

-- check constraint (PSR.CH_TXI_TEXT) violated
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST7', 'en', ''); &eh

-- Unknown text language
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST7', 'xx', 'Text type description'); &eh

-- Inactive text language
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST7', 'la', 'Text type description'); &eh

-- unique constraint (PSR.PK_TXTT) violated
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST1', 'en', 'Text type description'); &eh

-- value larger than specified precision allowed for this column
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST7', 'en', 'Text type description', 1e6); &eh

-- check constraint (PSR.CH_TXTT_ACTIVE_FLAG) violated
execute TEXT_TYPE.INSERT_TEXT_TYPE('TST7', 'en', 'Text type description', null, 'X'); &eh

-- Update text types
-- =================

-- Success cases
-- -------------

execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', 'en', 'Text!'); &eh
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', null, null, 1); &eh
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', null, null, null, 'N'); &eh
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', psLANG_CODE => 'en', psDescription => 'Text'); &eh
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', pnDISPLAY_SEQ => 2); &eh
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', psACTIVE_FLAG => 'Y'); &eh
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', pnDISPLAY_SEQ => null); &eh

-- Error cases
-- -----------

-- Description language cannot be specified without description text
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', 'en'); &eh

-- Unknown description language
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', 'xx', 'Text type description'); &eh

-- Inactive description language
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', 'la', 'Text type description'); &eh

-- no data found
execute TEXT_TYPE.UPDATE_TEXT_TYPE('XXX', 'en', 'Text type description'); &eh

-- Unknown description language
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', null, 'Text type description'); &eh

-- Nothing to be updated
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1'); &eh

-- Text type does not exist
execute TEXT_TYPE.UPDATE_TEXT_TYPE('XXX', pnDISPLAY_SEQ => 1); &eh

-- value larger than specified precision allowed for this column
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', pnDISPLAY_SEQ => 1e6); &eh

-- check constraint (PSR.CH_TXTT_ACTIVE_FLAG) violated
execute TEXT_TYPE.UPDATE_TEXT_TYPE('TST1', psACTIVE_FLAG => 'X'); &eh

-- Add text type descriptions
-- ==========================

-- Success cases
-- -------------

execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('TST1', 'fr', 'Texte'); &eh

-- Error cases
-- -----------

-- Unknown text language
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('TST1', 'xx', 'Text'); &eh

-- Inactive text language
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('TST1', 'la', 'Latin Text'); &eh

-- no data found
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('XXX', 'en', 'Component'); &eh

-- unique constraint (PSR.PK_TXI) violated
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('TST1', 'fr', 'Texte'); &eh

-- check constraint (PSR.CH_TXI_TEXT) violated
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('TST1', 'ru', ''); &eh

-- Remove text type descriptions
-- =============================

-- Error cases
-- -----------

-- no data found
execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('XXX', 'fr'); &eh

-- Cannot delete last mandatory text item
execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('TST2', 'en'); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('TST1', 'xx'); &eh

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TXTT_DESCRIPTION('TST1', 'fr'); &eh

-- Add text type text
-- ==================

-- Success cases
-- -------------

variable SEQ_NBR number
execute TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh

-- Error cases
-- -----------

-- Unknown text language
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh

-- Inactive text language
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh

-- no data found
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('XXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Unknown text type
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh

-- Only one text item of this type allowed
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh

-- No existing text of this type
execute :SEQ_NBR := 1; TEXT_TYPE.ADD_TXTT_TEXT('TST2', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- Text item sequence number greater than current maximum
execute :SEQ_NBR := 9; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh

-- check constraint (PSR.CH_TXI_TEXT) violated
execute :SEQ_NBR := null; TEXT_TYPE.ADD_TXTT_TEXT('TST1', 'NOTE', :SEQ_NBR, 'en', ''); &eh

-- Update text type text
-- =====================

-- Success cases
-- -------------

execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'NOTE', 1, 'fr', 'Updated French note'); &eh
execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'NOTE', 2, 'es', 'Updated Spanish note'); &eh
execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'NOTE', 2, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

-- Error cases
-- -----------

-- no data found
execute TEXT_TYPE.UPDATE_TXTT_TEXT('XXX', 'NOTE', 1, 'fr', 'Updated note'); &eh

-- Text item does not exist
execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'XXXX', 1, 'fr', 'Updated note'); &eh

-- Text item does not exist
execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'NOTE', 9, 'fr', 'Updated note'); &eh

-- Text item does not exist
execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'NOTE', 1, 'xx', 'Updated note'); &eh

-- check constraint (PSR.CH_TXI_TEXT) violated
execute TEXT_TYPE.UPDATE_TXTT_TEXT('TST1', 'NOTE', 1, 'fr', ''); &eh

-- Remove text type text
-- =====================

-- Error cases
-- -----------

-- no data found
execute TEXT_TYPE.REMOVE_TXTT_TEXT('XXX', 'NOTE', 1, 'en'); &eh

-- Text type must be specified
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', null); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'XXXX', 1, 'en'); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'NOTE', 9, 'en'); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'NOTE', 1, 'xx'); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST2', 'NOTE'); &eh

-- Cannot delete mandatory text type
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'DESCR'); &eh

-- Cannot delete last mandatory text item
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'DESCR', 1); &eh

-- Cannot delete last mandatory text item
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'DESCR', 1, 'en'); &eh

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'NOTE', 1, 'en'); &eh
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'NOTE', 1); &eh
execute TEXT_TYPE.REMOVE_TXTT_TEXT('TST1', 'NOTE'); &eh

-- Delete text types
-- =================

-- Error cases
-- -----------

-- Text type does not exist
execute TEXT_TYPE.DELETE_TEXT_TYPE('XXX'); &eh

-- Success cases
-- -------------

execute TEXT_TYPE.DELETE_TEXT_TYPE('TST6'); &eh

-- Set text type properties
-- ========================

-- Success cases
-- -------------

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST1', 'TXTT'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST2', 'TXTT', 'Y'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST3', 'TXTT', null, 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST4', 'TXTT', psMULTI_INSTANCE => 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST1', 'TXTT', 'Y', 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST1', 'TXTT'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST2', 'TXTT', 'N'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST3', 'TXTT', null, 'Y'); &eh
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST4', 'TXTT', psMULTI_INSTANCE => 'Y'); &eh

-- Error cases
-- -----------

-- integrity constraint (PSR.FK_TTP_TXTT) violated - parent key not found
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST9', 'TXTT'); &eh

-- integrity constraint (PSR.FK_TTP_TAB) violated - parent key not found
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST1', 'XXX'); &eh

-- check constraint (PSR.CH_TTP_MANDATORY) violated
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST1', 'TXTT', 'X'); &eh

-- check constraint (PSR.CH_TTP_MULTI_INSTANCE) violated
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('TST1', 'TXTT', null, 'X'); &eh

-- Set text type properties text
-- =============================

-- Success cases
-- -------------

execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'Initial English note'); &eh
execute TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'Updated English note'); &eh

-- Error cases
-- -----------

-- no data found
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST9', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- no data found
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'XXXX', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text type
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'XXX', :SEQ_NBR, 'en', 'English note'); &eh

-- Text item sequence number greater than current maximum
execute :SEQ_NBR := 9; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text language
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh

-- Inactive text language
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh

-- integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh

-- check constraint (PSR.CH_TXI_TEXT) violated
execute :SEQ_NBR := null; TEXT_TYPE.SET_TXP_TEXT('TST1', 'TXTT', 'NOTE', :SEQ_NBR, 'en', ''); &eh

-- Remove text type properties text
-- ================================

-- Error cases
-- -----------

-- no data found
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST9', 'TXTT', 'NOTE'); &eh

-- no data found
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'XXXX', 'NOTE'); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', 'XXXX'); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', 'NOTE', 9); &eh

-- No text to delete
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', 'NOTE', 1, 'xx'); &eh

-- Text type must be specified
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', null); &eh

-- Success cases
-- -------------

execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', 'NOTE', 1, 'en'); &eh
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', 'NOTE', 1); &eh
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST1', 'TXTT', 'NOTE'); &eh
execute TEXT_TYPE.REMOVE_TXP_TEXT('TST2', 'TXTT', 'NOTE', 1, 'en'); &eh

spool off

set echo off serveroutput off feedback on
