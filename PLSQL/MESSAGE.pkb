create or replace package body MESSAGE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_COMPONENT
-- ----------------------------------------
--
  procedure INSERT_COMPONENT
   (psCODE in COMPONENTS.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2,
    pnDISPLAY_SEQ in COMPONENTS.DISPLAY_SEQ%type := null,
    psACTIVE_FLAG in COMPONENTS.ACTIVE_FLAG%type := null)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.INSERT_COMPONENT',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    TEXT.INSERT_TEXT(nTXT_ID, 'LANG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    begin
      if psACTIVE_FLAG is null
      then
        insert into COMPONENTS (CODE, DISPLAY_SEQ, TXT_ID)
        values (psCODE, pnDISPLAY_SEQ, nTXT_ID);
      else
        insert into COMPONENTS (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
        values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
      end if;
    exception
      when DUP_VAL_ON_INDEX
      then MESSAGE.DISPLAY_MESSAGE('MSG', 1, 'en', 'Component already exists');
    --
      when others
      then if sqlcode = -2290
          and sqlerrm like '%CH_COMP_ACTIVE_FLAG%'
        then MESSAGE.DISPLAY_MESSAGE('MSG', 2, 'en', 'Active flag must be Y or N');
        else raise;
        end if;
    end;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_COMPONENT;
--
-- ----------------------------------------
-- UPDATE_COMPONENT
-- ----------------------------------------
--
  procedure UPDATE_COMPONENT
   (psCODE in COMPONENTS.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psDescription in varchar2 := null,
    pnDISPLAY_SEQ in COMPONENTS.DISPLAY_SEQ%type := -1e6,
    psACTIVE_FLAG in COMPONENTS.ACTIVE_FLAG%type := null)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_COMPONENT',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    if psDescription is not null
    then
      if psLANG_CODE is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 3, 'en', 'Description language must be specified');
      end if;
    --
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
      begin
        select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
      end;
    --
      TEXT.UPDATE_TEXT(nTXT_ID, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
    --
    elsif psLANG_CODE is not null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 7, 'en', 'Description language cannot be specified without description text');
    elsif pnDISPLAY_SEQ = -1e6
      and psACTIVE_FLAG is null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 8, 'en', 'Nothing to be updated');
    end if;
  --
    if nvl(pnDISPLAY_SEQ, 0) != -1e6
      or psACTIVE_FLAG is not null
    then
      begin
        update COMPONENTS
        set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
          ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG)
        where CODE = psCODE;
      --
        if sql%rowcount = 0
        then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
        end if;
      exception
        when others
        then if sqlcode = -2290
            and sqlerrm like '%CH_COMP_ACTIVE_FLAG%'
          then MESSAGE.DISPLAY_MESSAGE('MSG', 2, 'en', 'Active flag must be Y or N');
          else raise;
          end if;
      end;
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_COMPONENT;
--
-- ----------------------------------------
-- ADD_COMP_DESCRIPTION
-- ----------------------------------------
--
  procedure ADD_COMP_DESCRIPTION
   (psCODE in COMPONENTS.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2)
  is
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.ADD_COMP_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    ADD_COMP_TEXT(psCODE, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end ADD_COMP_DESCRIPTION;
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
-- ADD_COMP_TEXT
-- ----------------------------------------
--
  procedure ADD_COMP_TEXT
   (psCODE in COMPONENTS.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.ADD_COMP_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    begin
      select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
    end;
  --
    TEXT.INSERT_TEXT(nTXT_ID, null, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end ADD_COMP_TEXT;
--
-- ----------------------------------------
-- UPDATE_COMP_TEXT
-- ----------------------------------------
--
  procedure UPDATE_COMP_TEXT
   (psCODE in COMPONENTS.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_COMP_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    begin
      select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
    end;
  --
    TEXT.UPDATE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_COMP_TEXT;
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
    begin
      select TXT_ID into nTXT_ID from COMPONENTS where CODE = psCODE;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
    end;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 9, 'en', 'Text type must be specified');
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
-- DELETE_COMPONENT
-- ----------------------------------------
--
  procedure DELETE_COMPONENT
   (psCODE in COMPONENTS.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_COMPONENT', psCODE);
  --
    begin
      delete from COMPONENTS where CODE = psCODE;
    exception
      when others
      then
        if sqlcode = -2292  -- Integrity constraint violated - child record found
        then MESSAGE.DISPLAY_MESSAGE('MSG', 10, 'en', 'Component still in use');
        else raise;
        end if;
    end;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_COMPONENT;
--
-- ----------------------------------------
-- INSERT_MESSAGE
-- ----------------------------------------
--
  procedure INSERT_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in out MESSAGES.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psMessage in varchar2,
    psSEVERITY in MESSAGES.SEVERITY%type := null)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type;
    nMSG_SEQ_NBR_MAX COMPONENTS.MSG_SEQ_NBR_MAX%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.INSERT_MESSAGE',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
                               psSEVERITY || '~' || psLANG_CODE || '~' ||
                               to_char(length(psMessage)) || ':' || psMessage);
  --
    TEXT.INSERT_TEXT(nTXT_ID, 'MSG', 'MSG', nTXI_SEQ_NBR, psLANG_CODE, psMessage);
  --
    begin
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
      -- Check that given component exists and requested message sequence number is not greater than
      --  the current maximum.
      --
        begin
          select MSG_SEQ_NBR_MAX
          into nMSG_SEQ_NBR_MAX
          from COMPONENTS
          where CODE = psCOMP_CODE;
        exception
          when NO_DATA_FOUND
          then MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'en', 'Component does not exist');
        end;
      --
        if pnSEQ_NBR > nMSG_SEQ_NBR_MAX
        then MESSAGE.DISPLAY_MESSAGE('MSG', 11, 'en', 'Message sequence number greater than current maximum');
        end if;
      end if;
    --
      if psSEVERITY is null
      then
        insert into MESSAGES (COMP_CODE, SEQ_NBR, TXT_ID)
        values (psCOMP_CODE, pnSEQ_NBR, nTXT_ID);
      else
        insert into MESSAGES (COMP_CODE, SEQ_NBR, SEVERITY, TXT_ID)
        values (psCOMP_CODE, pnSEQ_NBR, psSEVERITY, nTXT_ID);
      end if;
    exception
      when DUP_VAL_ON_INDEX
      then MESSAGE.DISPLAY_MESSAGE('MSG', 12, 'en', 'Message already exists');
    --
      when others
      then if sqlcode = -2290
          and sqlerrm like '%CH_MSG_SEVERITY%'
        then MESSAGE.DISPLAY_MESSAGE('MSG', 13, 'en', 'Severity must be System error, Error, Warning or Information');
        else raise;
        end if;
    end;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_MESSAGE;
--
-- ----------------------------------------
-- UPDATE_MESSAGE
-- ----------------------------------------
--
  procedure UPDATE_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psMessage in varchar2 := null,
    psSEVERITY in MESSAGES.SEVERITY%type := null)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_MESSAGE',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
                               psSEVERITY || '~' || psLANG_CODE || '~' ||
                               to_char(length(psMessage)) || ':' || psMessage);
  --
    if psMessage is not null
    then
      if psLANG_CODE is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 14, 'en', 'Message language must be specified');
      end if;
    --
      begin
        select ACTIVE_FLAG into sActive from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('MSG', 15, 'en', 'Unknown message language');
      end;
    --
      if sActive = 'N'
      then MESSAGE.DISPLAY_MESSAGE('MSG', 16, 'en', 'Inactive message language');
      end if;
    --
      begin
        select TXT_ID
        into nTXT_ID
        from MESSAGES
        where COMP_CODE = psCOMP_CODE
        and SEQ_NBR = pnSEQ_NBR;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('MSG', 17, 'en', 'Message does not exist');
      end;
    --
      TEXT.UPDATE_TEXT(nTXT_ID, 'MSG', nTXI_SEQ_NBR, psLANG_CODE, psMessage);
    --
    elsif psLANG_CODE is not null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 18, 'en', 'Message language cannot be specified without message text');
    elsif psSEVERITY is null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 19, 'en', 'Nothing to be updated');
    end if;
  --
    if psSEVERITY is not null
    then
      begin
        update MESSAGES
        set SEVERITY = nvl(psSEVERITY, SEVERITY)
        where COMP_CODE = psCOMP_CODE
        and SEQ_NBR = pnSEQ_NBR;
      --
        if sql%rowcount = 0
        then MESSAGE.DISPLAY_MESSAGE('MSG', 17, 'en', 'Message does not exist');
        end if;
      exception
        when others
        then if sqlcode = -2290
            and sqlerrm like '%CH_MSG_SEVERITY%'
          then MESSAGE.DISPLAY_MESSAGE('MSG', 13, 'en', 'Severity must be System error, Error, Warning or Information');
          else raise;
          end if;
      end;
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_MESSAGE;
--
-- ----------------------------------------
-- ADD_MSG_MESSAGE
-- ----------------------------------------
--
  procedure ADD_MSG_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psMessage in varchar2)
  is
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.ADD_MSG_MESSAGE',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE ||
                               '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    ADD_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, 'MSG', nTXI_SEQ_NBR, psLANG_CODE, psMessage);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end ADD_MSG_MESSAGE;
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
-- ADD_MSG_TEXT
-- ----------------------------------------
--
  procedure ADD_MSG_TEXT
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
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.ADD_MSG_TEXT',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psTXTT_CODE ||
                               '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    begin
      select TXT_ID
      into nTXT_ID
      from MESSAGES
      where COMP_CODE = psCOMP_CODE
      and SEQ_NBR = pnSEQ_NBR;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('MSG', 17, 'en', 'Message does not exist');
    end;
  --
    TEXT.INSERT_TEXT(nTXT_ID, null, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end ADD_MSG_TEXT;
--
-- ----------------------------------------
-- UPDATE_MSG_TEXT
-- ----------------------------------------
--
  procedure UPDATE_MSG_TEXT
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in MESSAGES.SEQ_NBR%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_MSG_TEXT',
                             psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psTXTT_CODE ||
                               '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    begin
      select TXT_ID
      into nTXT_ID
      from MESSAGES
      where COMP_CODE = psCOMP_CODE
      and SEQ_NBR = pnSEQ_NBR;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('MSG', 17, 'en', 'Message does not exist');
    end;
  --
    TEXT.UPDATE_TEXT(nTXT_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_MSG_TEXT;
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
    begin
      select TXT_ID
      into nTXT_ID
      from MESSAGES
      where COMP_CODE = psCOMP_CODE
      and SEQ_NBR = pnSEQ_NBR;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('MSG', 17, 'en', 'Message does not exist');
    end;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('MSG', 9, 'en', 'Text type must be specified');
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
-- DELETE_MESSAGE
-- ----------------------------------------
--
  procedure DELETE_MESSAGE
   (psCOMP_CODE in MESSAGES.COMP_CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_MESSAGE',
                             psCOMP_CODE || '~' || pnSEQ_NBR);
  --
    delete from MESSAGES where COMP_CODE = psCOMP_CODE and SEQ_NBR = pnSEQ_NBR;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('MSG', 17, 'en', 'Message does not exist');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_MESSAGE;
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
    sMessagePrefix varchar2(100);
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
      then raise_application_error(-20001, '** Message not found ** ' || psEnglishMessage);
    end;
  --
    if psSEVERITY is not null
    then if psSEVERITY in ('S', 'E', 'W', 'I')
      then sSEVERITY := psSEVERITY;
      else sSEVERITY := 'S';
        sMessagePrefix := '** Invalid severity ** ';
      end if;
    end if;
  --
    case sSEVERITY
      when 'S' then nSQLCODE := -20001;
      when 'E' then nSQLCODE := -20002;
      when 'W' then nSQLCODE := -20003;
      when 'I' then nSQLCODE := -20004;
      else nSQLCODE := -20001;
        sMessagePrefix := '** Invalid severity ** ';
    end case;
  --
    sLONG_TEXT := nvl(sTEXT, sLONG_TEXT);
    sLONG_TEXT_EN := nvl(sTEXT_EN, sLONG_TEXT_EN);
  --
    if sLONG_TEXT is null
--      and sLONG_TEXT_EN is not null
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
