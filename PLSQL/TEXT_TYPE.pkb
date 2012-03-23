create or replace package body TEXT_TYPE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_TEXT_TYPE
-- ----------------------------------------
--
  procedure INSERT_TEXT_TYPE
   (psCODE in tmsTXTT_CODE,
    psLANG_CODE in tmsLANG_CODE,
    psDescription in tmsText,
    pnDISPLAY_SEQ in tnTXTT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in tmsTXTT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID tnTXT_ID;
    nSEQ_NBR tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_TEXT_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    TEXT.SET_TEXT(nTXT_ID, 'TXTT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into TEXT_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_TEXT_TYPE;
--
-- ----------------------------------------
-- UPDATE_TEXT_TYPE
-- ----------------------------------------
--
  procedure UPDATE_TEXT_TYPE
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in out tnTXTT_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psDescription in tsText := null,
    pnDISPLAY_SEQ in tnTXTT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in tsTXTT_ACTIVE_FLAG := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_TEXT_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTXTT_ROWID
    from TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is null
      then
        if pnDISPLAY_SEQ = -1e6
          and psACTIVE_FLAG is null
        then MESSAGE.DISPLAY_MESSAGE('TXTT', 3, 'Nothing to be updated');
        end if;
      else
        TEXT.SET_TEXT(nTXT_ID, 'TXTT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update TEXT_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xTXTT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 1, 'Text type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_TEXT_TYPE;
--
-- ----------------------------------------
-- SET_TEXT_TYPE
-- ----------------------------------------
--
  procedure SET_TEXT_TYPE
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in out tnTXTT_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psDescription in tsText := null,
    pnDISPLAY_SEQ in tnTXTT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in tsTXTT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_TEXT_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_TEXT_TYPE(psCODE, psLANG_CODE, psDescription,
                       case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                       nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_TEXT_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                       pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TEXT_TYPE;
--
-- ----------------------------------------
-- DELETE_TEXT_TYPE
-- ----------------------------------------
--
  procedure DELETE_TEXT_TYPE
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in tnTXTT_VERSION_NBR)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_TEXT_TYPE', psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTXTT_ROWID
    from TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from TEXT_TYPES where rowid = xTXTT_ROWID;
    --
      TEXT.DELETE_TEXT(nTXT_ID);
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 1, 'Text type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_TEXT_TYPE;
--
-- ----------------------------------------
-- SET_TXTT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_TXTT_DESCRIPTION
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in out tnTXTT_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psDescription in tmsText)
  is
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_TXTT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_TXTT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TXTT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_TXTT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_TXTT_DESCRIPTION
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in out tnTXTT_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_TXTT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_TXTT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_TXTT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_TXTT_TEXT
-- ----------------------------------------
--
  procedure SET_TXTT_TEXT
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in out tnTXTT_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in out tnTXI_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psText in tmsText)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_TXTT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTXTT_ROWID
    from TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.SET_TEXT(nTXT_ID, 'TXTT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update TEXT_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xTXTT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 1, 'Text type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TXTT_TEXT;
--
-- ----------------------------------------
-- REMOVE_TXTT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_TXTT_TEXT
   (psCODE in tmsTXTT_CODE,
    pnVERSION_NBR in out tnTXTT_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in tnTXI_SEQ_NBR := null,
    psLANG_CODE in tsLANG_CODE := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTXTT_VERSION_NBR;
    xTXTT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_TXTT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTXTT_ROWID
    from TEXT_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update TEXT_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xTXTT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 1, 'Text type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_TXTT_TEXT;
--
-- ----------------------------------------
-- INSERT_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure INSERT_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in tmsTXTT_CODE,
    psTAB_ALIAS in tmsTAB_ALIAS,
    psMANDATORY_FLAG in tmsTTP_MANDATORY_FLAG := 'Y',
    psMULTI_INSTANCE_FLAG in tmsTTP_MULTI_INSTANCE_FLAG := 'N',
    psLONG_TEXT_FLAG in tmsTTP_LONG_TEXT_FLAG := 'N')
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || psMANDATORY_FLAG || '~' ||
        psMULTI_INSTANCE_FLAG || '~' || psLONG_TEXT_FLAG);
  --
    insert into TEXT_TYPE_PROPERTIES
     (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG)
    values
     (psTXTT_CODE, psTAB_ALIAS, psMANDATORY_FLAG, psMULTI_INSTANCE_FLAG, psLONG_TEXT_FLAG);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- UPDATE_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure UPDATE_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in tmsTXTT_CODE,
    psTAB_ALIAS in tmsTAB_ALIAS,
    pnVERSION_NBR in out tnTTP_VERSION_NBR,
    psMANDATORY_FLAG in tsTTP_MANDATORY_FLAG := null,
    psMULTI_INSTANCE_FLAG in tsTTP_MULTI_INSTANCE_FLAG := null,
    psLONG_TEXT_FLAG in tsTTP_LONG_TEXT_FLAG := null)
  is
    nVERSION_NBR tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psMANDATORY_FLAG || '~' || psMULTI_INSTANCE_FLAG || '~' || psLONG_TEXT_FLAG);
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xTTP_ROWID
    from TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psMANDATORY_FLAG is null
        and psMULTI_INSTANCE_FLAG is null
        and psLONG_TEXT_FLAG is null
      then MESSAGE.DISPLAY_MESSAGE('TXTT', 3, 'Nothing to be updated');
      end if;
    --
      update TEXT_TYPE_PROPERTIES
      set MANDATORY_FLAG = nvl(psMANDATORY_FLAG, MANDATORY_FLAG),
        MULTI_INSTANCE_FLAG = nvl(psMULTI_INSTANCE_FLAG, MULTI_INSTANCE_FLAG),
        LONG_TEXT_FLAG = nvl(psLONG_TEXT_FLAG, LONG_TEXT_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xTTP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 2, 'Text type property has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- SET_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure SET_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in tmsTXTT_CODE,
    psTAB_ALIAS in tmsTAB_ALIAS,
    pnVERSION_NBR in out tnTTP_VERSION_NBR,
    psMANDATORY_FLAG in tsTTP_MANDATORY_FLAG := null,
    psMULTI_INSTANCE_FLAG in tsTTP_MULTI_INSTANCE_FLAG := null,
    psLONG_TEXT_FLAG in tsTTP_LONG_TEXT_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psMANDATORY_FLAG || '~' || psMULTI_INSTANCE_FLAG || '~' || psLONG_TEXT_FLAG);
  --
    if pnVERSION_NBR is null
    then
      INSERT_TEXT_TYPE_PROPERTIES
       (psTXTT_CODE, psTAB_ALIAS, psMANDATORY_FLAG, psMULTI_INSTANCE_FLAG, psLONG_TEXT_FLAG);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_TEXT_TYPE_PROPERTIES
       (psTXTT_CODE, psTAB_ALIAS, pnVERSION_NBR,
        psMANDATORY_FLAG, psMULTI_INSTANCE_FLAG, psLONG_TEXT_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- DELETE_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure DELETE_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in tmsTXTT_CODE,
    psTAB_ALIAS in tmsTAB_ALIAS,
    pnVERSION_NBR in tnTTP_VERSION_NBR)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_TEXT_TYPE_PROPERTIES',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTTP_ROWID
    from TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from TEXT_TYPE_PROPERTIES where rowid = xTTP_ROWID;
    --
      if nTXT_ID is not null
      then TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 2, 'Text type property has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- SET_TTP_TEXT
-- ----------------------------------------
--
  procedure SET_TTP_TEXT
   (psTXTT_CODE in tmsTXTT_CODE,
    psTAB_ALIAS in tmsTAB_ALIAS,
    pnVERSION_NBR in out tnTTP_VERSION_NBR,
    psTXTT_CODE_TEXT in tmsTXTT_CODE,
    pnSEQ_NBR in out tnTXI_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psText in tmsText)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_TTP_TEXT',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE_TEXT || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTTP_ROWID
    from TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.SET_TEXT(nTXT_ID, 'TTP', psTXTT_CODE_TEXT, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update TEXT_TYPE_PROPERTIES
      set TXT_ID = nTXT_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xTTP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 2, 'Text type property has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TTP_TEXT;
--
-- ----------------------------------------
-- REMOVE_TTP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_TTP_TEXT
   (psTXTT_CODE in tmsTXTT_CODE,
    psTAB_ALIAS in tmsTAB_ALIAS,
    pnVERSION_NBR in out tnTTP_VERSION_NBR,
    psTXTT_CODE_TEXT in tmsTXTT_CODE,
    pnSEQ_NBR in tnTXI_SEQ_NBR := null,
    psLANG_CODE in tsLANG_CODE := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnTTP_VERSION_NBR;
    xTTP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_TTP_TEXT',
      psTXTT_CODE || '~' || psTAB_ALIAS || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE_TEXT || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xTTP_ROWID
    from TEXT_TYPE_PROPERTIES
    where TXTT_CODE = psTXTT_CODE
    and TAB_ALIAS = psTAB_ALIAS
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE_TEXT, pnSEQ_NBR, psLANG_CODE);
    --
      update TEXT_TYPE_PROPERTIES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xTTP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('TXTT', 2, 'Text type property has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_TTP_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'TEXT_TYPE'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end TEXT_TYPE;
/

show errors
