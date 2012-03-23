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
   (psCODE in tmsCOMP_CODE,
    psLANG_CODE in tmsLANG_CODE,
    psDescription in tmsText,
    pnDISPLAY_SEQ in tnCOMP_DISPLAY_SEQ := null,
    psACTIVE_FLAG in tsCOMP_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID tnTXT_ID;
    nSEQ_NBR tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_COMPONENT',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    TEXT.SET_TEXT(nTXT_ID, 'COMP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into COMPONENTS (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_COMPONENT;
--
-- ----------------------------------------
-- UPDATE_COMPONENT
-- ----------------------------------------
--
  procedure UPDATE_COMPONENT
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in out tnCOMP_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psDescription in tsText := null,
    pnDISPLAY_SEQ in tnCOMP_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in tsCOMP_ACTIVE_FLAG := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_COMPONENT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xCOMP_ROWID
    from COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is null
      then
        if pnDISPLAY_SEQ = -1e6
          and psACTIVE_FLAG is null
        then MESSAGE.DISPLAY_MESSAGE('MSG', 7, 'Nothing to be updated');
        end if;
      else
        TEXT.SET_TEXT(nTXT_ID, 'COMP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update TEXT_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xCOMP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_COMPONENT;
--
-- ----------------------------------------
-- SET_COMPONENT
-- ----------------------------------------
--
  procedure SET_COMPONENT
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in out tnCOMP_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psDescription in tsText := null,
    pnDISPLAY_SEQ in tnCOMP_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in tsCOMP_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_COMPONENT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_COMPONENT(psCODE, psLANG_CODE, psDescription,
                       case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                       nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_COMPONENT(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                       pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_COMPONENT;
--
-- ----------------------------------------
-- DELETE_COMPONENT
-- ----------------------------------------
--
  procedure DELETE_COMPONENT
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in tnCOMP_VERSION_NBR)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_COMPONENT', psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xCOMP_ROWID
    from COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from COMPONENTS where rowid = xCOMP_ROWID;
    --
      TEXT.DELETE_TEXT(nTXT_ID);
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_COMPONENT;
--
-- ----------------------------------------
-- SET_COMP_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_COMP_DESCRIPTION
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in out tnCOMP_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psDescription in tmsText)
  is
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_COMP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_COMP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_COMP_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_COMP_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_COMP_DESCRIPTION
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in out tnCOMP_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_COMP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_COMP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_COMP_DESCRIPTION;
--
-- ----------------------------------------
-- SET_COMP_TEXT
-- ----------------------------------------
--
  procedure SET_COMP_TEXT
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in out tnCOMP_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in out tnTXI_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psText in tmsText)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nVERSION_NBR tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_COMP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xCOMP_ROWID
    from COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.SET_TEXT(nTXT_ID, 'COMP', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LANGUAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCOMP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_COMP_TEXT;
--
-- ----------------------------------------
-- REMOVE_COMP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_COMP_TEXT
   (psCODE in tmsCOMP_CODE,
    pnVERSION_NBR in out tnCOMP_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in tnTXI_SEQ_NBR := null,
    psLANG_CODE in tsLANG_CODE := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nVERSION_NBR tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_COMP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xCOMP_ROWID
    from COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update COMPONENTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCOMP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_COMP_TEXT;
--
-- ----------------------------------------
-- INSERT_MESSAGE
-- ----------------------------------------
--
  procedure INSERT_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in out tnMSG_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psMessage in tmsText,
    psSEVERITY in tsMSG_SEVERITY := 'E')
  is
    nMSG_SEQ_NBR_MAX tnMSG_SEQ_NBR;
    nTXT_ID tnTXT_ID;
    nSEQ_NBR tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psSEVERITY || '~' ||
        psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
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
      then MESSAGE.DISPLAY_MESSAGE('MSG', 8, 'Component does not exist');
      end if;
    else
    --
    -- Check that requested message sequence number is not greater than the current maximum.
    --
      select MSG_SEQ_NBR_MAX into nMSG_SEQ_NBR_MAX from COMPONENTS where CODE = psCOMP_CODE;
    --
      if pnSEQ_NBR > nMSG_SEQ_NBR_MAX
      then MESSAGE.DISPLAY_MESSAGE('MSG', 9, 'Message sequence number greater than current maximum');
      end if;
    end if;
  --
    TEXT.SET_TEXT(nTXT_ID, 'MSG', 'MSG', nSEQ_NBR, psLANG_CODE, psMessage);
  --
    insert into MESSAGES (COMP_CODE, SEQ_NBR, SEVERITY, TXT_ID)
    values (psCOMP_CODE, pnSEQ_NBR, psSEVERITY, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_MESSAGE;
--
-- ----------------------------------------
-- UPDATE_MESSAGE
-- ----------------------------------------
--
  procedure UPDATE_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    pnVERSION_NBR in out tnMSG_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psMessage in tsText := null,
    psSEVERITY in tsMSG_SEVERITY := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psSEVERITY || '~' || psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    if psMessage is null
    then
      if psLANG_CODE is not null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 10, 'Message language cannot be specified without message text');
      elsif psSEVERITY is null
      then MESSAGE.DISPLAY_MESSAGE('MSG', 7, 'Nothing to be updated');
      end if;
    end if;
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xMSG_ROWID
    from MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psMessage is not null
      then TEXT.SET_TEXT(nTXT_ID, 'MSG', 'MSG', nSEQ_NBR, psLANG_CODE, psMessage);
      end if;
    --
      update MESSAGES
      set SEVERITY = nvl(psSEVERITY, SEVERITY),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xMSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_MESSAGE;
--
-- ----------------------------------------
-- SET_MESSAGE
-- ----------------------------------------
--
  procedure SET_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in out tnMSG_SEQ_NBR,
    pnVERSION_NBR in out tnMSG_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psMessage in tsText := null,
    psSEVERITY in tsMSG_SEVERITY := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psSEVERITY || '~' || psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    if pnVERSION_NBR is null
    then
      INSERT_MESSAGE(psCOMP_CODE, pnSEQ_NBR, psLANG_CODE, psMessage, psSEVERITY);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_MESSAGE(psCOMP_CODE, pnSEQ_NBR, pnVERSION_NBR, psLANG_CODE, psMessage, psSEVERITY);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_MESSAGE;
--
-- ----------------------------------------
-- DELETE_MESSAGE
-- ----------------------------------------
--
  procedure DELETE_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    pnVERSION_NBR in tnMSG_VERSION_NBR)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xMSG_ROWID
    from MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from MESSAGES where ROWID = xMSG_ROWID;
    --
      TEXT.DELETE_TEXT(nTXT_ID);
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_MESSAGE;
--
-- ----------------------------------------
-- SET_MSG_MESSAGE
-- ----------------------------------------
--
  procedure SET_MSG_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    pnVERSION_NBR in out tnMSG_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psMessage in tmsText)
  is
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_MSG_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    SET_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, pnVERSION_NBR, 'MSG', nSEQ_NBR, psLANG_CODE, psMessage);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_MSG_MESSAGE;
--
-- ----------------------------------------
-- REMOVE_MSG_MESSAGE
-- ----------------------------------------
--
  procedure REMOVE_MSG_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    pnVERSION_NBR in out tnMSG_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_MSG_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE);
  --
    REMOVE_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, pnVERSION_NBR, 'MSG', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_MSG_MESSAGE;
--
-- ----------------------------------------
-- SET_MSG_TEXT
-- ----------------------------------------
--
  procedure SET_MSG_TEXT
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    pnVERSION_NBR in out tnMSG_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnTXI_SEQ_NBR in out tnTXI_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psText in tmsText)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_MSG_TEXT',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xMSG_ROWID
    from MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.SET_TEXT(nTXT_ID, 'MSG', psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
    --
      update MESSAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xMSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_MSG_TEXT;
--
-- ----------------------------------------
-- REMOVE_MSG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_MSG_TEXT
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    pnVERSION_NBR in out tnMSG_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnTXI_SEQ_NBR in tnTXI_SEQ_NBR := null,
    psLANG_CODE in tsLANG_CODE := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_MSG_TEXT',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xMSG_ROWID
    from MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE);
    --
      update MESSAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xMSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_MSG_TEXT;
--
-- ----------------------------------------
-- DISPLAY_MESSAGE
-- ----------------------------------------
--
  procedure DISPLAY_MESSAGE
   (psCOMP_CODE in tmsCOMP_CODE,
    pnSEQ_NBR in tnMSG_SEQ_NBR,
    psEnglishMessage in tsText := null,
    psSEVERITY in tsMSG_SEVERITY := null)
  is
    sSEVERITY tsMSG_SEVERITY;
    sMESSAGE L_MESSAGES.MESSAGE%type;
    sTEXT_EN TEXT_ITEMS.TEXT%type;
    nSQLCODE integer;
    sMessagePrefix varchar2(100) := psCOMP_CODE || to_char(-pnSEQ_NBR, 'S0999') || ': ';
  --
    function GET_MESSAGE
     (pnSEQ_NBR in L_MESSAGES.SEQ_NBR%type)
      return L_MESSAGES.MESSAGE%type
    is
      sMESSAGE L_MESSAGES.MESSAGE%type;
    begin
      select MESSAGE
      into sMESSAGE
      from L_MESSAGES
      where COMP_CODE = 'MSG'
      and SEQ_NBR = pnSEQ_NBR;
    --
      return '** ' || sMESSAGE || ' ** ';
    end GET_MESSAGE;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DISPLAY_MESSAGE',
      psCOMP_CODE || '~' || pnSEQ_NBR || '~' || psSEVERITY|| '~' ||
        to_char(length(psEnglishMessage)) || ':' || psEnglishMessage);
  --
    begin
      select MSG.SEVERITY, MSG.MESSAGE, TXI.TEXT
      into sSEVERITY, sMESSAGE, sTEXT_EN
      from L_MESSAGES MSG
      left outer join TEXT_ITEMS TXI
        on TXI.TXT_ID = MSG.TXT_ID
        and TXI.TXTT_CODE = 'MSG'
        and TXI.SEQ_NBR = 1
        and TXI.LANG_CODE = 'en'
      where MSG.COMP_CODE = psCOMP_CODE
      and MSG.SEQ_NBR = pnSEQ_NBR;
    exception
      when NO_DATA_FOUND
      then raise_application_error(-20001,
                                   sMessagePrefix || GET_MESSAGE(1)  -- Message not found
                                     || psEnglishMessage);
    end;
  --
    if psSEVERITY is not null
    then if psSEVERITY in ('S', 'E', 'W', 'I')
      then sSEVERITY := psSEVERITY;
      else sSEVERITY := 'S';
        sMessagePrefix := sMessagePrefix || GET_MESSAGE(2);  -- Invalid severity
      end if;
    end if;
  --
    case sSEVERITY
      when 'S' then nSQLCODE := -20001;
      when 'E' then nSQLCODE := -20002;
      when 'W' then nSQLCODE := -20003;
      when 'I' then nSQLCODE := -20004;
      else nSQLCODE := -20001;
        sMessagePrefix := sMessagePrefix || GET_MESSAGE(2);  -- Invalid severity
    end case;
  --
    if psEnglishMessage is not null
    then if sTEXT_EN is null
      then sMessagePrefix := sMessagePrefix || GET_MESSAGE(3);  -- No stored English message
      elsif sTEXT_EN != psEnglishMessage
      then sMessagePrefix := sMessagePrefix || GET_MESSAGE(4);  -- English message mismatch
      end if;
    end if;
  --
    raise_application_error(nSQLCODE, sMessagePrefix || sMESSAGE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DISPLAY_MESSAGE;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'MESSAGE'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end MESSAGE;
/

show errors
