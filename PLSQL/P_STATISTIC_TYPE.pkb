create or replace package body P_STATISTIC_TYPE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnSTCT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsSTCT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'STCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into STATISTIC_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_STATISTIC_TYPE;
--
-- ----------------------------------------
-- UPDATE_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure UPDATE_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCT_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCT_ROWID
    from STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'STCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update STATISTIC_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 1, 'Statistic type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_STATISTIC_TYPE;
--
-- ----------------------------------------
-- SET_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure SET_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_STATISTIC_TYPE(psCODE, psLANG_CODE, psDescription,
                            case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                            nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STATISTIC_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                            pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STATISTIC_TYPE;
--
-- ----------------------------------------
-- DELETE_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in P_BASE.tnSTCT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCT_ROWID
    from STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from STATISTIC_TYPES where rowid = xSTCT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 1, 'Statistic type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_STATISTIC_TYPE;
--
-- ----------------------------------------
-- SET_STCT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_STCT_DESCRIPTION
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_STCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STCT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_STCT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_STCT_DESCRIPTION
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_STCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_STCT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_STCT_TEXT
-- ----------------------------------------
--
  procedure SET_STCT_TEXT
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCT_ROWID
    from STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'STCT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update STATISTIC_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 1, 'Statistic type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STCT_TEXT;
--
-- ----------------------------------------
-- REMOVE_STCT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STCT_TEXT
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCT_ROWID
    from STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update STATISTIC_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 1, 'Statistic type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_STCT_TEXT;
--
-- ----------------------------------------
-- INSERT_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnSTCG_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsSTCG_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'STCG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into STATISTIC_GROUPS (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_STATISTIC_GROUP;
--
-- ----------------------------------------
-- UPDATE_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure UPDATE_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCG_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCG_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCG_ROWID
    from STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'STCG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update STATISTIC_GROUPS
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 2, 'Statistic group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- SET_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure SET_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCG_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCG_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_STATISTIC_GROUP(psCODE, psLANG_CODE, psDescription,
                             case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                             nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STATISTIC_GROUP(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                             pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STATISTIC_GROUP;
--
-- ----------------------------------------
-- DELETE_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in P_BASE.tnSTCG_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCG_ROWID
    from STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from STATISTIC_GROUPS where rowid = xSTCG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 2, 'Statistic group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- SET_STCG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_STCG_DESCRIPTION
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STCG_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_STCG_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STCG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_STCG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_STCG_DESCRIPTION
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STCG_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_STCG_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_STCG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_STCG_TEXT
-- ----------------------------------------
--
  procedure SET_STCG_TEXT
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STCG_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCG_ROWID
    from STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'STCG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update STATISTIC_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 2, 'Statistic group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STCG_TEXT;
--
-- ----------------------------------------
-- REMOVE_STCG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STCG_TEXT
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STCG_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCG_ROWID
    from STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update STATISTIC_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 2, 'Statistic group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_STCG_TEXT;
--
-- ----------------------------------------
-- INSERT_STATISTIC_TYPE_GROUPING
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_TYPE_GROUPING
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC_TYPE_GROUPING',
      psSTCG_CODE || '~' || psSTCT_CODE);
  --
    insert into STATISTIC_TYPES_IN_GROUPS (STCG_CODE, STCT_CODE)
    values (psSTCG_CODE, psSTCT_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_STATISTIC_TYPE_GROUPING;
--
-- ----------------------------------------
-- DELETE_STATISTIC_TYPE_GROUPING
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_TYPE_GROUPING
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in P_BASE.tnSTCTG_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
    xSTCTG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC_TYPE_GROUPING',
      psSTCG_CODE || '~' || psSTCT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCTG_ROWID
    from STATISTIC_TYPES_IN_GROUPS
    where STCG_CODE = psSTCG_CODE
    and STCT_CODE = psSTCT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from STATISTIC_TYPES_IN_GROUPS where rowid = xSTCTG_ROWID;
    --
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 3, 'Statistic type grouping has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_STATISTIC_TYPE_GROUPING;
--
-- ----------------------------------------
-- SET_STCTG_TEXT
-- ----------------------------------------
--
  procedure SET_STCTG_TEXT
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCTG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
    xSTCTG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STCTG_TEXT',
      psSTCG_CODE || '~' || psSTCT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCTG_ROWID
    from STATISTIC_TYPES_IN_GROUPS
    where STCG_CODE = psSTCG_CODE
    and STCT_CODE = psSTCT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'STCTG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update STATISTIC_TYPES_IN_GROUPS
      set TXT_ID = nTXT_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 3, 'Statistic type grouping has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STCTG_TEXT;
--
-- ----------------------------------------
-- REMOVE_STCTG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STCTG_TEXT
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCTG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
    xSTCTG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STCTG_TEXT',
      psSTCG_CODE || '~' || psSTCT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTCTG_ROWID
    from STATISTIC_TYPES_IN_GROUPS
    where STCG_CODE = psSTCG_CODE
    and STCT_CODE = psSTCT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update STATISTIC_TYPES_IN_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STCT', 3, 'Statistic type grouping has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_STCTG_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'STCT'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_STATISTIC_TYPE;
/

show errors
