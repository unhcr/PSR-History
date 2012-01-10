-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when sqlcode = -20009 then 12 else 1 end))"

var TXT_ID number
var TXT_ID1 number
var TXT_ID2 number
var SEQ_NBR number
var SEQ_NBR1 number
var SEQ_NBR2 number

-- execute TEXT_ITEM.INSERT_TEXT_ITEM('INACT', 'en', 'Inactive', null, 'N');
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'TXTT', 'DESCR', :SEQ_NBR, 'en', 'Inactive');
insert into TEXT_TYPES (CODE, ACTIVE_FLAG, TXT_ID) values ('INACT', 'N', :TXT_ID);

set echo on serveroutput on feedback off

spool test_TEXT.log

-- Insert text
-- ===========

-- Success cases
-- -------------

execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note 1'); :TXT_ID1 := :TXT_ID; &eh
execute :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note 2'); :SEQ_NBR1 := :SEQ_NBR; &eh
execute TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'es', rpad('x', 1001, unistr('\00F1'))); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'en', 'English description'); :TXT_ID2 := :TXT_ID; :SEQ_NBR2 := :SEQ_NBR; &eh

-- Error cases
-- -----------

-- Either text identifier or table alias must be specified
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Cannot specify a text item sequence number without a text identifier
execute :TXT_ID := null; :SEQ_NBR := 1; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown table alias
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'XXXX', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text type
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'XXXX', :SEQ_NBR, 'en', 'English note'); &eh

-- Inactive text type
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'INACT', :SEQ_NBR, 'en', 'English note'); &eh

-- Text of this type not allowed for this table
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh

-- Unknown text identifier
execute :TXT_ID := 9999999; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Text of this type not allowed for this table
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'MSG', :SEQ_NBR, 'en', 'English message'); &eh

-- Wrong table for this text identifier
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'TXTT', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text type
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'XXXX', :SEQ_NBR, 'en', 'English note'); &eh

-- Inactive text type
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'INACT', :SEQ_NBR, 'en', 'English note'); &eh

-- Only one text item of this type allowed
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'DESCR', :SEQ_NBR, 'en', 'English description'); &eh

-- No existing text of this type
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Text item sequence number greater than current maximum
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := 9; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Unknown text language
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'de', 'German note'); &eh

-- Inactive text language
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, null, 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh

-- Text message already exists
execute :TXT_ID := :TXT_ID1; :SEQ_NBR := :SEQ_NBR1; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh

-- Text message must be specified
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', ''); &eh

-- Update text
-- ===========

-- Success cases
-- -------------

execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'en', 'English note 3'); &eh
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'es', 'Spanish note 3'); &eh
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'fr', rpad('French note ', 1001, unistr('\8BF4'))); &eh
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'fr', rpad('French note ', 1001, '$')); &eh

-- Error cases
-- -----------

-- Text item does not exist
execute TEXT.UPDATE_TEXT(9999999, 'NOTE', :SEQ_NBR1, 'en', 'English note'); &eh

-- Text item does not exist
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'XXXX', :SEQ_NBR1, 'en', 'English note'); &eh

-- Text item does not exist
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', 9999, 'en', 'English note'); &eh

-- Text item does not exist
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'de', 'German note'); &eh

-- Text message must be specified
execute TEXT.UPDATE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'en', ''); &eh

-- Delete text
-- ===========

-- Error cases
-- -----------

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'de'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', 9999); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(:TXT_ID1, 'XXXX'); &eh

-- No text to delete
execute TEXT.DELETE_TEXT(9999999); &eh

-- Cannot delete last mandatory text item
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2, 'en'); &eh

-- Cannot delete last mandatory text item
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2); &eh

-- Cannot delete mandatory text type
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR'); &eh

-- Success cases
-- -------------

execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1, 'fr'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE', :SEQ_NBR1); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1, 'NOTE'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID1); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID); &eh
execute :TXT_ID := null; :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute :SEQ_NBR := null; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'en', 'English description'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID, 'NOTE'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID); &eh
execute :TXT_ID := :TXT_ID2; :SEQ_NBR := :SEQ_NBR2; TEXT.INSERT_TEXT(:TXT_ID, 'LANG', 'DESCR', :SEQ_NBR, 'fr', 'French description'); &eh
execute TEXT.DELETE_TEXT(:TXT_ID2, 'DESCR', :SEQ_NBR2, 'en'); &eh

set echo off serveroutput off feedback on

spool off
