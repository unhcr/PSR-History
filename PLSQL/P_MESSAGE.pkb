create or replace package body P_MESSAGE is
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
   (psCODE in P_BASE.tmsCOMP_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnCOMP_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsCOMP_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_COMPONENT',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'COMP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_COMPONENTS (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
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
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in out P_BASE.tnCOMP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnCOMP_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsCOMP_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_COMPONENT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCOMP_ROWID
    from T_COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'COMP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_TEXT_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xCOMP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_COMPONENT;
--
-- ----------------------------------------
-- SET_COMPONENT
-- ----------------------------------------
--
  procedure SET_COMPONENT
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in out P_BASE.tnCOMP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnCOMP_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsCOMP_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_COMPONENT',
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_COMPONENT;
--
-- ----------------------------------------
-- DELETE_COMPONENT
-- ----------------------------------------
--
  procedure DELETE_COMPONENT
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in P_BASE.tnCOMP_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_COMPONENT', psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCOMP_ROWID
    from T_COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_COMPONENTS where rowid = xCOMP_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
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
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in out P_BASE.tnCOMP_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_COMP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_COMP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
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
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in out P_BASE.tnCOMP_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_COMP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_COMP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
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
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in out P_BASE.tnCOMP_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID T_DATA_ITEMS.ID%type;
    nVERSION_NBR P_BASE.tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_COMP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCOMP_ROWID
    from T_COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'COMP', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_COMPONENTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCOMP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
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
   (psCODE in P_BASE.tmsCOMP_CODE,
    pnVERSION_NBR in out P_BASE.tnCOMP_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID T_DATA_ITEMS.ID%type;
    nVERSION_NBR P_BASE.tnCOMP_VERSION_NBR;
    xCOMP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_COMP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xCOMP_ROWID
    from T_COMPONENTS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_COMPONENTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xCOMP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      DISPLAY_MESSAGE('MSG', 5, 'Component has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_COMP_TEXT;
--
-- ----------------------------------------
-- INSERT_MESSAGE
-- ----------------------------------------
--
  procedure INSERT_MESSAGE
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in out P_BASE.tnMSG_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psMessage in P_BASE.tmsText,
    psSEVERITY in P_BASE.tsMSG_SEVERITY := 'E')
  is
    nMSG_SEQ_NBR_MAX P_BASE.tnMSG_SEQ_NBR;
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psSEVERITY || '~' ||
        psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    if pnSEQ_NBR is null
    then
    --
    -- Get next message sequence number for component.
    --
      update T_COMPONENTS
      set MSG_SEQ_NBR_MAX = MSG_SEQ_NBR_MAX + 1
      where CODE = psCOMP_CODE
      returning MSG_SEQ_NBR_MAX into pnSEQ_NBR;
    --
      if sql%rowcount = 0
      then DISPLAY_MESSAGE('MSG', 7, 'Component does not exist');
      end if;
    else
    --
    -- Check that requested message sequence number is not greater than the current maximum.
    --
      select MSG_SEQ_NBR_MAX into nMSG_SEQ_NBR_MAX from T_COMPONENTS where CODE = psCOMP_CODE;
    --
      if pnSEQ_NBR > nMSG_SEQ_NBR_MAX
      then DISPLAY_MESSAGE('MSG', 8, 'Message sequence number greater than current maximum');
      end if;
    end if;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'MSG', 'MSG', nSEQ_NBR, psLANG_CODE, psMessage);
  --
    insert into T_MESSAGES (COMP_CODE, SEQ_NBR, SEVERITY, ITM_ID)
    values (psCOMP_CODE, pnSEQ_NBR, psSEVERITY, nITM_ID);
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
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in out P_BASE.tnMSG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psMessage in P_BASE.tsText := null,
    psSEVERITY in P_BASE.tsMSG_SEVERITY := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psSEVERITY || '~' || psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xMSG_ROWID
    from T_MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psMessage is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'MSG', 'MSG', nSEQ_NBR, psLANG_CODE, psMessage);
      end if;
    --
      update T_MESSAGES
      set SEVERITY = nvl(psSEVERITY, SEVERITY),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xMSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_MESSAGE;
--
-- ----------------------------------------
-- SET_MESSAGE
-- ----------------------------------------
--
  procedure SET_MESSAGE
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in out P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in out P_BASE.tnMSG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psMessage in P_BASE.tsText := null,
    psSEVERITY in P_BASE.tsMSG_SEVERITY := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_MESSAGE',
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_MESSAGE;
--
-- ----------------------------------------
-- DELETE_MESSAGE
-- ----------------------------------------
--
  procedure DELETE_MESSAGE
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in P_BASE.tnMSG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xMSG_ROWID
    from T_MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_MESSAGES where ROWID = xMSG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
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
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in out P_BASE.tnMSG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psMessage in P_BASE.tmsText)
  is
    nSEQ_NBR T_TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_MSG_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psMessage)) || ':' || psMessage);
  --
    SET_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, pnVERSION_NBR, 'MSG', nSEQ_NBR, psLANG_CODE, psMessage);
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
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in out P_BASE.tnMSG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_MSG_MESSAGE',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE);
  --
    REMOVE_MSG_TEXT(psCOMP_CODE, pnSEQ_NBR, pnVERSION_NBR, 'MSG', 1, psLANG_CODE);
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
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in out P_BASE.tnMSG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnTXI_SEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_MSG_TEXT',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xMSG_ROWID
    from T_MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'MSG', psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
    --
      update T_MESSAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xMSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
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
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    pnVERSION_NBR in out P_BASE.tnMSG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnTXI_SEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnMSG_VERSION_NBR;
    xMSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_MSG_TEXT',
      psCOMP_CODE || '~' || to_char(pnSEQ_NBR) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xMSG_ROWID
    from T_MESSAGES
    where COMP_CODE = psCOMP_CODE
    and SEQ_NBR = pnSEQ_NBR
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE);
    --
      update T_MESSAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xMSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      DISPLAY_MESSAGE('MSG', 6, 'Message has been updated by another user');
    end if;
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
   (psCOMP_CODE in P_BASE.tmsCOMP_CODE,
    pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR,
    psEnglishMessage in P_BASE.tsText := null,
    psSEVERITY in P_BASE.tsMSG_SEVERITY := null)
  is
    sSEVERITY P_BASE.tsMSG_SEVERITY;
    sMESSAGE P_BASE.tsNormalText;
    sTEXT_EN P_BASE.tsNormalText;
    nSQLCODE integer;
    sMessagePrefix varchar2(100) := psCOMP_CODE || to_char(-pnSEQ_NBR, 'S0999') || ': ';
  --
    function GET_MESSAGE
     (pnSEQ_NBR in P_BASE.tnMSG_SEQ_NBR)
      return P_BASE.tsText
    is
      sMESSAGE P_BASE.tsNormalText;
    begin
      select MESSAGE
      into sMESSAGE
      from MESSAGES
      where COMP_CODE = 'MSG'
      and SEQ_NBR = pnSEQ_NBR;
    --
      return '** ' || sMESSAGE || ' ** ';
    end GET_MESSAGE;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DISPLAY_MESSAGE',
      psCOMP_CODE || '~' || pnSEQ_NBR || '~' || psSEVERITY|| '~' ||
        to_char(length(psEnglishMessage)) || ':' || psEnglishMessage);
  --
    begin
      select MSG.SEVERITY, MSG.MESSAGE, TXI.TEXT
      into sSEVERITY, sMESSAGE, sTEXT_EN
      from MESSAGES MSG
      left outer join T_TEXT_ITEMS TXI
        on TXI.ITM_ID = MSG.ITM_ID
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DISPLAY_MESSAGE;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'MSG'
  then DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_MESSAGE;
/

show errors
