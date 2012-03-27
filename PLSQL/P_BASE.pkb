create or replace package body P_BASE is
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'BASE'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  select DATE_VALUE into gdMIN_DATE from SYSTEM_PARAMETERS where CODE = 'MINIMUM DATE';
--
  select DATE_VALUE into gdMAX_DATE from SYSTEM_PARAMETERS where CODE = 'MAXIMUM DATE';
--
  select DATE_VALUE into gdFALSE_DATE from SYSTEM_PARAMETERS where CODE = 'FALSE DATE';
--
end P_BASE;
/

show errors
