create or replace package body P_DIMENSION is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure INSERT_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnDIMT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsDIMT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'DIMT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_DIMENSION_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_DIMENSION_TYPE;
--
-- ----------------------------------------
-- UPDATE_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure UPDATE_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnDIMT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIMT_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'DIMT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_DIMENSION_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIMT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 1, 'Dimension type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_DIMENSION_TYPE;
--
-- ----------------------------------------
-- SET_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure SET_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnDIMT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIMT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_DIMENSION_TYPE(psCODE, psLANG_CODE, psDescription,
                            case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                            nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_DIMENSION_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                            pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DIMENSION_TYPE;
--
-- ----------------------------------------
-- DELETE_DIMENSION_TYPE
-- ----------------------------------------
--
  procedure DELETE_DIMENSION_TYPE
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in P_BASE.tnDIMT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_DIMENSION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_DIMENSION_TYPES where rowid = xDIMT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 1, 'Dimension type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_DIMENSION_TYPE;
--
-- ----------------------------------------
-- SET_DIMT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_DIMT_DESCRIPTION
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DIMT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_DIMT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DIMT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_DIMT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_DIMT_DESCRIPTION
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_DIMT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_DIMT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_DIMT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_DIMT_TEXT
-- ----------------------------------------
--
  procedure SET_DIMT_TEXT
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DIMT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'DIMT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_DIMENSION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIMT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 1, 'Dimension type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DIMT_TEXT;
--
-- ----------------------------------------
-- REMOVE_DIMT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_DIMT_TEXT
   (psCODE in P_BASE.tmsDIMT_CODE,
    pnVERSION_NBR in out P_BASE.tnDIMT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIMT_VERSION_NBR;
    xDIMT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_DIMT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIMT_ROWID
    from T_DIMENSION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_DIMENSION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIMT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 1, 'Dimension type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_DIMT_TEXT;
--
-- ----------------------------------------
-- INSERT_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure INSERT_DIMENSION_VALUE
   (pnID out P_BASE.tnDIM_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psDIMT_CODE in P_BASE.tmsDIMT_CODE,
    psCODE in P_BASE.tmsDIM_CODE,
    pnDISPLAY_SEQ in P_BASE.tnDIM_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsDIM_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_DIMENSION_VALUE',
      psDIMT_CODE || '~' || psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG ||
        '~' || psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'DIM', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_DIMENSION_VALUES (ID, DIMT_CODE, CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (DIM_SEQ.nextval, psDIMT_CODE, psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID)
    returning ID into pnID;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_DIMENSION_VALUE;
--
-- ----------------------------------------
-- UPDATE_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure UPDATE_DIMENSION_VALUE
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psCODE in P_BASE.tsDIM_CODE := null,
    pnDISPLAY_SEQ in P_BASE.tnDIM_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIM_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_DIMENSION_VALUE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psCODE ||
        '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'DIM', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_DIMENSION_VALUES
      set CODE = nvl(psCODE, CODE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 2, 'Dimension value has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_DIMENSION_VALUE;
--
-- ----------------------------------------
-- SET_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure SET_DIMENSION_VALUE
   (pnID in out P_BASE.tnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psDIMT_CODE in P_BASE.tsDIMT_CODE := null,
    psCODE in P_BASE.tsDIM_CODE := null,
    pnDISPLAY_SEQ in P_BASE.tnDIM_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDIM_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DIMENSION_VALUE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psDIMT_CODE || '~' ||
        psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_DIMENSION_VALUE(pnID, psLANG_CODE, psDescription, psDIMT_CODE, psCODE,
                             case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                             nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_DIMENSION_VALUE(pnID, pnVERSION_NBR, psLANG_CODE, psDescription, psCODE,
                             pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DIMENSION_VALUE;
--
-- ----------------------------------------
-- DELETE_DIMENSION_VALUE
-- ----------------------------------------
--
  procedure DELETE_DIMENSION_VALUE
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in P_BASE.tnDIM_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_DIMENSION_VALUE',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_DIMENSION_VALUES where rowid = xDIM_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 2, 'Dimension value has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_DIMENSION_VALUE;
--
-- ----------------------------------------
-- SET_DIM_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_DIM_DESCRIPTION
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DIM_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_DIM_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DIM_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_DIM_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_DIM_DESCRIPTION
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_DIM_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_DIM_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_DIM_DESCRIPTION;
--
-- ----------------------------------------
-- SET_DIM_TEXT
-- ----------------------------------------
--
  procedure SET_DIM_TEXT
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DIM_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'DIM', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_DIMENSION_VALUES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 2, 'Dimension value has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DIM_TEXT;
--
-- ----------------------------------------
-- REMOVE_DIM_TEXT
-- ----------------------------------------
--
  procedure REMOVE_DIM_TEXT
   (pnID in P_BASE.tmnDIM_ID,
    pnVERSION_NBR in out P_BASE.tnDIM_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
    xDIM_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_DIM_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDIM_ROWID
    from T_DIMENSION_VALUES
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_DIMENSION_VALUES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDIM_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DIM', 2, 'Dimension value has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_DIM_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'DIM'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_DIMENSION;
/

show errors
