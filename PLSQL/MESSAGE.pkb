create or replace package body MESSAGE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_COMPONENT
-- ----------------------------------------
--
  procedure SET_COMPONENT
   (psCODE in COMPONENTS.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psDescription in varchar2 := null,
    pnDISPLAY_SEQ in COMPONENTS.DISPLAY_SEQ%type := -1e6,
    psACTIVE_FLAG in COMPONENTS.ACTIVE_FLAG%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
    sActive varchar2(1);
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_COMPONENT',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check if component already exists.
  --
    begin
      select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
    exception
      when NO_DATA_FOUND
      then nTXT_ID := null;
        nSEQ_NBR := null;
    end;
  --
    if psDescription is null
    then
      if nTXT_ID is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 1, 'en', 'Description must be specified for new component');
      elsif psLANG_CODE is not null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 2, 'en', 'Description language cannot be specified without description text');
      elsif pnDISPLAY_SEQ = -1e6
        and psACTIVE_FLAG is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 3, 'en', 'Nothing to be updated');
      end if;
    else
      begin
        select ACTIVE_FLAG into sActive from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('MSG', 4, 'en', 'Unknown description language');
      end;
    --
      if sActive = 'N'
      then MESSAGE.DISPLAY_MESSAGE('MSG', 5, 'en', 'Inactive description language');
      end if;
    --
      TEXT.SET_TEXT(nTXT_ID, 'COMP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
    end if;
  --
    merge into COMPONENTS COMP
    using
     (select psCODE CODE from DUAL) INP
    on (COMP.CODE = INP.CODE)
    when matched then
      update
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG)
      where nvl(pnDISPLAY_SEQ, 0) != -1e6
        or psACTIVE_FLAG is not null
    when not matched then
      insert
       (CODE, DISPLAY_SEQ, ACTIVE_FLAG,
        TXT_ID)
      values
       (psCODE, case when pnDISPLAY_SEQ != -1e6 then pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'),
        nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_COMPONENT;
--
-- ----------------------------------------
-- DELETE_COMPONENT
-- ----------------------------------------
--
  procedure DELETE_COMPONENT
   (psCODE in COMPONENTS.CODE%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_COMPONENT', psCODE);
  --
    delete from COMPONENTS where CODE = psCODE returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_COMPONENT;
--
-- ----------------------------------------
-- SET_COMP_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_COMP_DESCRIPTION
   (psCODE in COMPONENTS.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2)
  is
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_COMP_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_COMP_TEXT(psCODE, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_COMP_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_COMP_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_COMP_DESCRIPTION
   (psCODE in COMPONENTS.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_COMP_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE);
  --
    REMOVE_COMP_TEXT(psCODE, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_COMP_DESCRIPTION;
--
-- ----------------------------------------
-- SET_COMP_TEXT
-- ----------------------------------------
--
  procedure SET_COMP_TEXT
   (psCODE in COMPONENTS.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_COMP_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
  --
    TEXT.SET_TEXT(nTXT_ID, null, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_COMP_TEXT;
--
-- ----------------------------------------
-- REMOVE_COMP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_COMP_TEXT
   (psCODE in COMPONENTS.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_COMP_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 7, 'en', 'Text type must be specified');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_COMP_TEXT;
--
-- ----------------------------------------
-- SET_MESSAGE
-- ----------------------------------------
--
  procedure SET_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in out MESSAGES.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psMessage in varchar2 := null,
    psSEVERITY in MESSAGES.SEVERITY%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
    sActive varchar2(1);
    nMSG_SEQ_NBR_MAX COMPONENTS.MSG_SEQ_NBR_MAX%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_MESSAGE',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
                               psSEVERITY || '~' || psLANG_CODE || '~' ||
                               to_char(length(psMessage)) || ':' || psMessage);
  --
  -- Check if message already exists.
  --
    begin
      select TXT_ID
      into nTXT_ID
      from MESSAGES
      where COMP_CODE = psCOMP_CODE
      and SEQ_NBR = pnSEQ_NBR;
    exception
      when NO_DATA_FOUND
      then nTXT_ID := null;
        nTXI_SEQ_NBR := null;
    end;
  --
    if psMessage is null
    then
      if nTXT_ID is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 8, 'en', 'Message text must be specified for new message');
      elsif psLANG_CODE is not null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 9, 'en', 'Message language cannot be specified without message text');
      elsif psSEVERITY is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 3, 'en', 'Nothing to be updated');
      end if;
    else
      begin
        select ACTIVE_FLAG into sActive from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('MSG', 10, 'en', 'Unknown message language');
      end;
    --
      if sActive = 'N'
      then MESSAGE.DISPLAY_MESSAGE('MSG', 11, 'en', 'Inactive message language');
      end if;
    --
      TEXT.SET_TEXT(nTXT_ID, 'MSG', 'MSG', nTXI_SEQ_NBR, psLANG_CODE, psMessage);
    end if;
  --
    if pnSEQ_NBR is null
    then
    --
    -- Get next message sequence number for component.
    --
      update COMPONENTS
      set MSG_SEQ_NBR_MAX = MSG_SEQ_NBR_MAX + 1
      where CODE = psCOMP_CODE
      returning MSG_SEQ_NBR_MAX into pnSEQ_NBR;
    --
      if sql%rowcount = 0
      then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
      end if;
    else
    --
    -- Check that requested message sequence number is not greater than the current maximum.
    --
      select MSG_SEQ_NBR_MAX into nMSG_SEQ_NBR_MAX from COMPONENTS where CODE = psCOMP_CODE;
    --
      if pnSEQ_NBR > nMSG_SEQ_NBR_MAX
      then MESSAGE.DISPLAY_MESSAGE('MSG', 12, 'en', 'Message sequence number greater than current maximum');
      end if;
    end if;
  --
    merge into MESSAGES MSG
    using
     (select psCOMP_CODE COMP_CODE, pnSEQ_NBR SEQ_NBR from DUAL) INP
    on (MSG.COMP_CODE = INP.COMP_CODE and MSG.SEQ_NBR = INP.SEQ_NBR)
    when matched then
      update
      set SEVERITY = nvl(psSEVERITY, SEVERITY)
      where psSEVERITY is not null
    when not matched then
      insert (COMP_CODE, SEQ_NBR, SEVERITY, TXT_ID)
      values (psCOMP_CODE, pnSEQ_NBR, nvl(psSEVERITY, 'E'), nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_MESSAGE;
--
-- ----------------------------------------
-- DELETE_MESSAGE
-- ----------------------------------------
--
  procedure DELETE_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_MESSAGE',
                             psCOMP_CODE || '~' || pnSEQ_NBR);
  --
    delete from MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('MSG', 13, 'en', 'Message does not exist');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_MESSAGE;
--
-- ----------------------------------------
-- SET_MSG_MESSAGE
-- ----------------------------------------
--
  procedure SET_MSG_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psMessage in varchar2)
  is
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_MSG_MESSAGE',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE ||
                               '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    SET_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, 'MSG', nTXI_SEQ_NBR, psLANG_CODE, psMessage);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_MSG_MESSAGE;
--
-- ----------------------------------------
-- REMOVE_MSG_MESSAGE
-- ----------------------------------------
--
  procedure REMOVE_MSG_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_MSG_MESSAGE',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, 'MSG', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_MSG_MESSAGE;
--
-- ----------------------------------------
-- SET_MSG_TEXT
-- ----------------------------------------
--
  procedure SET_MSG_TEXT
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_MSG_TEXT',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psTXTT_CODE ||
                               '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from MESSAGES where COMP_CODE = psCOMP_CODE and SEQ_NBR = pnSEQ_NBR;
  --
    TEXT.SET_TEXT(nTXT_ID, null, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_MSG_TEXT;
--
-- ----------------------------------------
-- REMOVE_MSG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_MSG_TEXT
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_MSG_TEXT',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
                               psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID into nTXT_ID from MESSAGES where COMP_CODE = psCOMP_CODE and SEQ_NBR = pnSEQ_NBR;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 7, 'en', 'Text type must be specified');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_MSG_TEXT;
--
-- ----------------------------------------
-- DISPLAY_MESSAGE
-- ----------------------------------------
--
  procedure DISPLAY_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psEnglishMessage in varchar2 := null,
    psSEVERITY in MESSAGES.SEVERITY%type := null)
  is
    sSEVERITY MESSAGES.SEVERITY%type;
    sTEXT TEXT_ITEMS.TEXT%type;
    sLONG_TEXT varchar2(30000);
    sTEXT_EN TEXT_ITEMS.TEXT%type;
    sLONG_TEXT_EN varchar2(30000);
    nSQLCODE integer;
    sMessagePrefix varchar2(100) := psCOMP_CODE || to_char(-pnSEQ_NBR, 'S0999') || ': ';
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DISPLAY_MESSAGE',
                             psCOMP_CODE || '~' || pnSEQ_NBR || '~' ||
                               psLANG_CODE|| '~' || psSEVERITY|| '~' ||
                               to_char(length(psEnglishMessage)) || ':' || psEnglishMessage);
  --
    begin
      select MSG.SEVERITY, TXI1.TEXT, TXI1.LONG_TEXT, TXI2.TEXT, TXI2.LONG_TEXT
      into sSEVERITY, sTEXT, sLONG_TEXT, sTEXT_EN, sLONG_TEXT_EN
      from MESSAGES MSG
      left outer join TEXT_ITEMS TXI1
        on TXI1.TXT_ID = MSG.TXT_ID
        and TXI1.TXTT_CODE = 'MSG'
        and TXI1.SEQ_NBR = 1
        and TXI1.LANG_CODE = psLANG_CODE
      left outer join TEXT_ITEMS TXI2
        on TXI2.TXT_ID = MSG.TXT_ID
        and TXI2.TXTT_CODE = 'MSG'
        and TXI2.SEQ_NBR = 1
        and TXI2.LANG_CODE = 'en'
      where MSG.COMP_CODE = psCOMP_CODE
      and MSG.SEQ_NBR = pnSEQ_NBR;
    exception
      when NO_DATA_FOUND
      then raise_application_error(-20001,
                                   sMessagePrefix || '** Message not found ** ' ||
                                     psEnglishMessage);
    end;
  --
    if psSEVERITY is not null
    then if psSEVERITY in ('S', 'E', 'W', 'I')
      then sSEVERITY := psSEVERITY;
      else sSEVERITY := 'S';
        sMessagePrefix := sMessagePrefix || '** Invalid severity ** ';
      end if;
    end if;
  --
    case sSEVERITY
      when 'S' then nSQLCODE := -20001;
      when 'E' then nSQLCODE := -20002;
      when 'W' then nSQLCODE := -20003;
      when 'I' then nSQLCODE := -20004;
      else nSQLCODE := -20001;
        sMessagePrefix := sMessagePrefix || '** Invalid severity ** ';
    end case;
  --
    sLONG_TEXT := nvl(sTEXT, sLONG_TEXT);
    sLONG_TEXT_EN := nvl(sTEXT_EN, sLONG_TEXT_EN);
  --
    if sLONG_TEXT is null
    then sMessagePrefix := sMessagePrefix || '** No preferred language message ** ';
    end if;
  --
    if psEnglishMessage is not null
    then if sLONG_TEXT_EN is null
      then sMessagePrefix := sMessagePrefix || '** No stored English message ** ';
      elsif sLONG_TEXT_EN != psEnglishMessage
      then sMessagePrefix := sMessagePrefix || '** English message mismatch ** ';
      end if;
    end if;
  --
    raise_application_error(nSQLCODE, sMessagePrefix ||
                                        coalesce(sLONG_TEXT, sLONG_TEXT_EN, psEnglishMessage,
                                                 '** No message found **'));
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DISPLAY_MESSAGE;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'MESSAGE'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'en', 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'en', 'Module version mismatch');
  end if;
--
end MESSAGE;
/

show errors
