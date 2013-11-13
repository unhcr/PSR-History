create or replace package body P_CONTEXT is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_USERID
-- ----------------------------------------
--
  procedure SET_USERID
   (psUSERID in P_BASE.tmsUSR_USERID)
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.SET_USERID', psUSERID);
  --
    dbms_session.set_context('PSR', 'USERID', psUSERID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_USERID;
--
-- ----------------------------------------
-- CLEAR_USERID
-- ----------------------------------------
--
  procedure CLEAR_USERID
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.CLEAR_USERID');
  --
    dbms_session.clear_context('PSR', attribute => 'USERID');
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CLEAR_USERID;
--
-- ----------------------------------------
-- CLEAR_CONTEXT
-- ----------------------------------------
--
  procedure CLEAR_CONTEXT
  is
  begin
    P_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.CLEAR_CONTEXT');
  --
    dbms_session.clear_context('PSR');
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CLEAR_CONTEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'CTX'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_CONTEXT;
/

show errors
