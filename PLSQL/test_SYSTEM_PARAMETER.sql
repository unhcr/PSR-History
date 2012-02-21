-- Test set-up
-- ===========

define eh = "exception when others then dbms_output.put_line(substr(sqlerrm, case when substr(sqlerrm, 12, 5) = 'ORA-2' then 12 else 1 end))"

set echo on serveroutput on feedback off recsepchar "." sqlprompt "        " sqlnumber off

column DATA_TYPE format A9
column CHAR_VALUE format A60
column LONG_TEXT format A150

spool test_SYSTEM_PARAMETER.log

-- Set system parameters
-- =====================

-- Success cases
-- -------------

execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST1', 'C', 'Character parameter'); &eh
execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST2', 'N', null, 3.14159); &eh
execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST3', 'D', null, null, date '2012-01-01'); &eh
execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST1', 'C', 'Updated character parameter'); &eh
execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST2', 'N', pnNUM_VALUE => 2.71828); &eh
execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST3', 'C', psCHAR_VALUE => 'Changed data type'); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE
from SYSTEM_PARAMETERS SYP
order by SYP.CODE;

-- Error cases
-- -----------

execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST9', 'X', 'X'); &eh
-- ORA-02290: check constraint (PSR.CH_SYP_DATA_TYPE) violated

execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST9', 'CC', 'X'); &eh
-- ORA-12899: value too large for column "PSR"."SYSTEM_PARAMETERS"."DATA_TYPE" (actual: 2, maximum: 1)

execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST9', 'C'); &eh
-- ORA-02290: check constraint (PSR.CH_SYP_DATA_TYPE) violated

execute SYSTEM_PARAMETER.SET_SYSTEM_PARAMETER('TEST9', 'C', null, 999); &eh
-- ORA-02290: check constraint (PSR.CH_SYP_DATA_TYPE) violated

-- Set system parameter text
-- =========================

-- Success cases
-- -------------

variable SEQ_NBR number
execute SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'en', 'English note'); &eh
execute SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'es', 'New Spanish note'); &eh
execute :SEQ_NBR := 1; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'fr', 'Updated French note'); &eh
execute :SEQ_NBR := 2; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'es', 'Updated Spanish note'); &eh
execute :SEQ_NBR := 2; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'es', rpad('Updated Spanish note ', 1001, unistr('\00F1'))); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE, SYP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_PARAMETERS SYP
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = SYP.TXT_ID
where SYP.CODE = 'TEST3'
order by SYP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Error cases
-- -----------

execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'xx', 'Unknown note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'la', 'Latin note'); &eh
-- TXT-0005: Inactive text language

execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('XXXX', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'XXXX', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'DESCR', :SEQ_NBR, 'fr', 'French note'); &eh
-- ORA-02291: integrity constraint (PSR.FK_TTH_TTP) violated - parent key not found

execute :SEQ_NBR := 1; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST2', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0006: Cannot specify a text item sequence number without a text identifier

execute :SEQ_NBR := 9; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'fr', 'French note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := null; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'en', ''); &eh
-- TXT-0001: Text must be specified

execute :SEQ_NBR := 1; SYSTEM_PARAMETER.SET_SYP_TEXT('XXXX', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- ORA-01403: no data found

execute :SEQ_NBR := 1; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'XXXX', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0002: Unknown text type

execute :SEQ_NBR := 9; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'fr', 'Updated note'); &eh
-- TXT-0010: Text item sequence number greater than current maximum

execute :SEQ_NBR := 1; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'xx', 'Updated note'); &eh
-- TXT-0004: Unknown text language

execute :SEQ_NBR := 1; SYSTEM_PARAMETER.SET_SYP_TEXT('TEST3', 'NOTE', :SEQ_NBR, 'fr', ''); &eh
-- TXT-0001: Text must be specified

-- Remove system parameter text
-- ====================

-- Error cases
-- -----------

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('XXXX', 'NOTE', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', null); &eh
-- SYP-0007: Text type must be specified

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', 'XXXX', 1, 'en'); &eh
-- ORA-01403: no data found

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', 'NOTE', 9, 'en'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', 'NOTE', 1, 'xx'); &eh
-- TXT-0011: No text to delete

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST2', 'NOTE'); &eh
-- ORA-01403: no data found

-- Success cases
-- -------------

execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', 'NOTE', 1, 'en'); &eh
execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', 'NOTE', 1); &eh
execute SYSTEM_PARAMETER.REMOVE_SYP_TEXT('TEST3', 'NOTE'); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE, SYP.TXT_ID,
  TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE, TXI.TEXT, TXI.LONG_TEXT
from SYSTEM_PARAMETERS SYP
left outer join TEXT_ITEMS TXI
  on TXI.TXT_ID = SYP.TXT_ID
where SYP.CODE = 'TEST3'
order by SYP.CODE, TXI.TXTT_CODE, TXI.SEQ_NBR, TXI.LANG_CODE;

-- Delete system parameters
-- ========================

-- Error cases
-- -----------

execute SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('TEST9'); &eh
-- SYP-0001: System parameter does not exist

-- Success cases
-- -------------

execute SYSTEM_PARAMETER.DELETE_SYSTEM_PARAMETER('TEST3'); &eh

select SYP.CODE, SYP.DATA_TYPE, SYP.CHAR_VALUE, SYP.NUM_VALUE, SYP.DATE_VALUE
from SYSTEM_PARAMETERS SYP
order by SYP.CODE;

set echo off serveroutput off feedback on recsepchar " "

@check_orphan_TXT_ID

rollback;

spool off

@login
