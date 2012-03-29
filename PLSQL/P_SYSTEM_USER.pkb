create or replace package body P_SYSTEM_USER is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_SYSTEM_USER
-- ----------------------------------------
--
  procedure INSERT_SYSTEM_USER
   (psUSERID in P_BASE.tmsUSR_USERID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText,
    psLOCKED_FLAG in P_BASE.tmsUSR_LOCKED_FLAG := 'N',
    psTEMPLATE_FLAG in P_BASE.tmsUSR_TEMPLATE_FLAG := 'N')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_SYSTEM_USER',
      psUSERID || '~' || psLOCKED_FLAG || '~' || psTEMPLATE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'USR', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    insert into SYSTEM_USERS (USERID, LOCKED_FLAG, TEMPLATE_FLAG, TXT_ID)
    values (psUSERID, psLOCKED_FLAG, psTEMPLATE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_SYSTEM_USER;
--
-- ----------------------------------------
-- UPDATE_SYSTEM_USER
-- ----------------------------------------
--
  procedure UPDATE_SYSTEM_USER
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnUSR_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    psLOCKED_FLAG in P_BASE.tsUSR_LOCKED_FLAG := null,
    psTEMPLATE_FLAG in P_BASE.tsUSR_TEMPLATE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUSR_VERSION_NBR;
    xUSR_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_SYSTEM_USER',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psLOCKED_FLAG || '~' ||
        psTEMPLATE_FLAG || '~' || psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUSR_ROWID
    from SYSTEM_USERS
    where USERID = psUSERID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psName is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'USR', 'DESCR', nSEQ_NBR, psLANG_CODE, psName);
      end if;
    --
      update SYSTEM_USERS
      set LOCKED_FLAG = nvl(psLOCKED_FLAG, LOCKED_FLAG),
        TEMPLATE_FLAG = nvl(psTEMPLATE_FLAG, TEMPLATE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xUSR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 1, 'System user has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_SYSTEM_USER;
--
-- ----------------------------------------
-- SET_SYSTEM_USER
-- ----------------------------------------
--
  procedure SET_SYSTEM_USER
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnUSR_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    psLOCKED_FLAG in P_BASE.tsUSR_LOCKED_FLAG := null,
    psTEMPLATE_FLAG in P_BASE.tsUSR_TEMPLATE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_SYSTEM_USER',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psLOCKED_FLAG || '~' ||
        psTEMPLATE_FLAG || '~' || psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    if pnVERSION_NBR is null
    then
      INSERT_SYSTEM_USER(psUSERID, psLANG_CODE, psName,
                         nvl(psLOCKED_FLAG, 'N'), nvl(psTEMPLATE_FLAG, 'N'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_SYSTEM_USER(psUSERID, pnVERSION_NBR, psLANG_CODE, psName,
                         psLOCKED_FLAG, psTEMPLATE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_SYSTEM_USER;
--
-- ----------------------------------------
-- DELETE_SYSTEM_USER
-- ----------------------------------------
--
  procedure DELETE_SYSTEM_USER
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in P_BASE.tnUSR_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUSR_VERSION_NBR;
    xUSR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_SYSTEM_USER',
      psUSERID || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUSR_ROWID
    from SYSTEM_USERS
    where USERID = psUSERID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from SYSTEM_USERS where rowid = xUSR_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 1, 'System user has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_SYSTEM_USER;
--
-- ----------------------------------------
-- SET_USR_NAME
-- ----------------------------------------
--
  procedure SET_USR_NAME
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnUSR_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_USR_NAME',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    SET_USR_TEXT(psUSERID, pnVERSION_NBR, 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_USR_NAME;
--
-- ----------------------------------------
-- REMOVE_USR_NAME
-- ----------------------------------------
--
  procedure REMOVE_USR_NAME
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnUSR_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_USR_NAME',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_USR_TEXT(psUSERID, pnVERSION_NBR, 'NAME', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_USR_NAME;
--
-- ----------------------------------------
-- SET_USR_TEXT
-- ----------------------------------------
--
  procedure SET_USR_TEXT
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnUSR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUSR_VERSION_NBR;
    xUSR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_USR_TEXT',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUSR_ROWID
    from SYSTEM_USERS
    where USERID = psUSERID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'USR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update SYSTEM_USERS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xUSR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 1, 'System user has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_USR_TEXT;
--
-- ----------------------------------------
-- REMOVE_USR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_USR_TEXT
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnUSR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUSR_VERSION_NBR;
    xUSR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_USR_TEXT',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUSR_ROWID
    from SYSTEM_USERS
    where USERID = psUSERID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update SYSTEM_USERS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xUSR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 1, 'System user has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_USR_TEXT;
--
-- ----------------------------------------
-- INSERT_USER_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure INSERT_USER_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsUATT_CODE,
    psDATA_TYPE in P_BASE.tmsUATT_DATA_TYPE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnUATT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsUATT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_USER_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG ||
        '~' || psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'UATT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into USER_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_USER_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- UPDATE_USER_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_USER_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUATT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsUATT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnUATT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsUATT_ACTIVE_FLAG := null)
  is
    sDATA_TYPE P_BASE.tsUATT_DATA_TYPE;
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUATT_VERSION_NBR;
    xUATT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
    sDummy varchar2(1);
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_USER_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, TXT_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nTXT_ID, nVERSION_NBR, xUATT_ROWID
    from USER_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
  -- Check if data type is to be changed and user attributes of this type already exist.
  --
    if psDATA_TYPE != sDATA_TYPE
    then
      begin
        select 'x' into sDummy from USER_ATTRIBUTES where UATT_CODE = psCODE;
      --
        raise TOO_MANY_ROWS;
      exception
        when NO_DATA_FOUND then null;
      --
        when TOO_MANY_ROWS
        then P_MESSAGE.DISPLAY_MESSAGE('USR', 5, 'Cannot update data type of user attribute type already in use');
      end;
    end if;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'USR', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update USER_ATTRIBUTE_TYPES
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xUATT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 2, 'User attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_USER_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_USER_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_USER_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUATT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsUATT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnUATT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsUATT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_USER_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_USER_ATTRIBUTE_TYPE(psCODE, psDATA_TYPE, psLANG_CODE, psDescription,
                                 case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                                 nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_USER_ATTRIBUTE_TYPE(psCODE, pnVERSION_NBR, psDATA_TYPE, psLANG_CODE, psDescription,
                                 pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_USER_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_USER_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_USER_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in P_BASE.tnUATT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUATT_VERSION_NBR;
    xUATT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_USER_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUATT_ROWID
    from USER_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from USER_ATTRIBUTE_TYPES where rowid = xUATT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 2, 'User attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_USER_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_UATT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_UATT_DESCRIPTION
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUATT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_UATT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_UATT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_UATT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_UATT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_UATT_DESCRIPTION
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUATT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_UATT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_UATT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_UATT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_UATT_TEXT
-- ----------------------------------------
--
  procedure SET_UATT_TEXT
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUATT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUATT_VERSION_NBR;
    xUATT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_UATT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUATT_ROWID
    from USER_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'TXTT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update USER_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xUATT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 2, 'User attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_UATT_TEXT;
--
-- ----------------------------------------
-- REMOVE_UATT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_UATT_TEXT
   (psCODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUATT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUATT_VERSION_NBR;
    xUATT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_UATT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUATT_ROWID
    from USER_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update USER_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xUATT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 2, 'User attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_UATT_TEXT;
--
-- ----------------------------------------
-- INSERT_USER_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_USER_ATTRIBUTE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psUATT_CODE in P_BASE.tmsUATT_CODE,
    psCHAR_VALUE in P_BASE.tsUAT_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnUAT_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdUAT_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsUATT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsUATT_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_USER_ATTRIBUTE',
      psUSERID || '~' || psUATT_CODE || '~' || psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from USER_ATTRIBUTE_TYPES
    where CODE = psUATT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('USR', 6, 'Inactive user attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE('USR', 7, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into USER_ATTRIBUTES (USERID, UATT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (psUSERID, psUATT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_USER_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_USER_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_USER_ATTRIBUTE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psUATT_CODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUAT_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsUAT_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnUAT_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdUAT_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsUATT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsUATT_ACTIVE_FLAG;
    nVERSION_NBR P_BASE.tnUAT_VERSION_NBR;
    xUAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_USER_ATTRIBUTE',
      psUSERID || '~' || psUATT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    begin
      select DATA_TYPE, ACTIVE_FLAG
      into sDATA_TYPE, sACTIVE_FLAG
      from USER_ATTRIBUTE_TYPES
      where CODE = psUATT_CODE;
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE('USR', 8, 'Unknown user attribute type');
    end;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('USR', 6, 'Inactive user attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE('USR', 7, 'Attribute of the correct type must be specified');
    end case;
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xUAT_ROWID
    from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update USER_ATTRIBUTES
      set CHAR_VALUE = nvl(psCHAR_VALUE, CHAR_VALUE),
        NUM_VALUE = nvl(pnNUM_VALUE, NUM_VALUE),
        DATE_VALUE = nvl(pdDATE_VALUE, DATE_VALUE),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xUAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 3, 'User attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_USER_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_USER_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_USER_ATTRIBUTE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psUATT_CODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUAT_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsUAT_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnUAT_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdUAT_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_USER_ATTRIBUTE',
      psUSERID || '~' || psUATT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_USER_ATTRIBUTE(psUSERID, psUATT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_USER_ATTRIBUTE(psUSERID, psUATT_CODE, pnVERSION_NBR,
                            psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_USER_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_USER_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_USER_ATTRIBUTE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psUATT_CODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in P_BASE.tnUAT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUAT_VERSION_NBR;
    xUAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.DELETE_USER_ATTRIBUTE',
                             psUSERID || '~' || psUATT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUAT_ROWID
    from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from USER_ATTRIBUTES where rowid = xUAT_ROWID;
    --
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 3, 'User attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_USER_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_UAT_TEXT
-- ----------------------------------------
--
  procedure SET_UAT_TEXT
   (psUSERID in P_BASE.tmsUSR_USERID,
    psUATT_CODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUAT_VERSION_NBR;
    xUAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_UAT_TEXT',
      psUSERID || '~' || psUATT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUAT_ROWID
    from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'UAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update USER_ATTRIBUTES
      set TXT_ID = nTXT_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xUAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 3, 'User attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_UAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_UAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_UAT_TEXT
   (psUSERID in P_BASE.tmsUSR_USERID,
    psUATT_CODE in P_BASE.tmsUATT_CODE,
    pnVERSION_NBR in out P_BASE.tnUAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnUAT_VERSION_NBR;
    xUAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_UAT_TEXT',
      psUSERID || '~' || psUATT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xUAT_ROWID
    from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update USER_ATTRIBUTES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xUAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 3, 'User attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_UAT_TEXT;
--
-- ----------------------------------------
-- INSERT_USER_LANG_PREFERENCE
-- ----------------------------------------
--
  procedure INSERT_USER_LANG_PREFERENCE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    pnPREF_SEQ in P_BASE.tnULP_PREF_SEQ)
  is
    sACTIVE_FLAG P_BASE.tsLANG_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_USER_LANG_PREFERENCE',
      psUSERID || '~' || psLANG_CODE || '~' || to_char(pnPREF_SEQ));
  --
    select ACTIVE_FLAG into sACTIVE_FLAG from LANGUAGES where CODE = psLANG_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('USR', 9, 'Inactive preference language');
    end if;
  --
    insert into USER_LANGUAGE_PREFERENCES (USERID, LANG_CODE, PREF_SEQ)
    values (psUSERID, psLANG_CODE, pnPREF_SEQ);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_USER_LANG_PREFERENCE;
--
-- ----------------------------------------
-- UPDATE_USER_LANG_PREFERENCE
-- ----------------------------------------
--
  procedure UPDATE_USER_LANG_PREFERENCE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    pnVERSION_NBR in out P_BASE.tnULP_VERSION_NBR,
    pnPREF_SEQ in P_BASE.tnULP_PREF_SEQ)
  is
    nVERSION_NBR P_BASE.tnULP_VERSION_NBR;
    xULP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_USER_LANG_PREFERENCE',
      psUSERID || '~' || psLANG_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnPREF_SEQ));
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xULP_ROWID
    from USER_LANGUAGE_PREFERENCES
    where USERID = psUSERID
    and LANG_CODE = psLANG_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update USER_LANGUAGE_PREFERENCES
      set PREF_SEQ = pnPREF_SEQ,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xULP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 4, 'User language preference has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_USER_LANG_PREFERENCE;
--
-- ----------------------------------------
-- SET_USER_LANG_PREFERENCE
-- ----------------------------------------
--
  procedure SET_USER_LANG_PREFERENCE
   (psUSERID in P_BASE.tmsUSR_USERID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    pnVERSION_NBR in out P_BASE.tnULP_VERSION_NBR,
    pnPREF_SEQ in P_BASE.tnULP_PREF_SEQ)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_USER_LANG_PREFERENCE',
      psUSERID || '~' || psLANG_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnPREF_SEQ));
  --
    if pnVERSION_NBR is null
    then
      INSERT_USER_LANG_PREFERENCE(psUSERID, psLANG_CODE, pnPREF_SEQ);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_USER_LANG_PREFERENCE(psUSERID, psLANG_CODE, pnVERSION_NBR, pnPREF_SEQ);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_USER_LANG_PREFERENCE;
--
-- ----------------------------------------
-- REMOVE_USER_LANG_PREFERENCE
-- ----------------------------------------
--
  procedure REMOVE_USER_LANG_PREFERENCE
   (psUSERID in P_BASE.tmsUSR_USERID,
    pnVERSION_NBR in out P_BASE.tnULP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    pnPREF_SEQ in P_BASE.tnULP_PREF_SEQ := null)
  is
    nVERSION_NBR P_BASE.tnULP_VERSION_NBR;
    xULP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_USER_LANG_PREFERENCE',
      psUSERID || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(pnPREF_SEQ));
  --
    if psLANG_CODE is not null
    then
      select VERSION_NBR, rowid
      into nVERSION_NBR, xULP_ROWID
      from USER_LANGUAGE_PREFERENCES
      where USERID = psUSERID
      and LANG_CODE = psLANG_CODE
      for update;
    else
      select VERSION_NBR, rowid
      into nVERSION_NBR, xULP_ROWID
      from USER_LANGUAGE_PREFERENCES
      where USERID = psUSERID
      and PREF_SEQ = pnPREF_SEQ
      for update;
    end if;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from USER_LANGUAGE_PREFERENCES where rowid = xULP_ROWID;
    else
      P_MESSAGE.DISPLAY_MESSAGE('USR', 4, 'User language preference has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_USER_LANG_PREFERENCE;
--
-- ----------------------------------------
-- USER_LOGIN
-- ----------------------------------------
--
  procedure USER_LOGIN
   (psUSERID in P_BASE.tmsUSR_USERID)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sComponent || '.USER_LOGIN', psUSERID);
  --
    P_CONTEXT.SET_USERID(psUSERID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end USER_LOGIN;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'USR'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_SYSTEM_USER;
/

show errors
