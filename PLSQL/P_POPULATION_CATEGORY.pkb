create or replace package body P_POPULATION_CATEGORY is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_POPULATION_CATEGORY
-- ----------------------------------------
--
  procedure INSERT_POPULATION_CATEGORY
   (psCODE in P_BASE.tmsPOPC_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnPOPC_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsPOPC_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_POPULATION_CATEGORY',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'POPC', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_POPULATION_CATEGORIES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_POPULATION_CATEGORY;
--
-- ----------------------------------------
-- UPDATE_POPULATION_CATEGORY
-- ----------------------------------------
--
  procedure UPDATE_POPULATION_CATEGORY
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in out P_BASE.tnPOPC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPOPC_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPOPC_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPOPC_VERSION_NBR;
    xPOPC_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_POPULATION_CATEGORY',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPOPC_ROWID
    from T_POPULATION_CATEGORIES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'POPC', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_POPULATION_CATEGORIES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPOPC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('POPC', 1, 'Population category has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_POPULATION_CATEGORY;
--
-- ----------------------------------------
-- SET_POPULATION_CATEGORY
-- ----------------------------------------
--
  procedure SET_POPULATION_CATEGORY
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in out P_BASE.tnPOPC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPOPC_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPOPC_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPULATION_CATEGORY',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_POPULATION_CATEGORY(psCODE, psLANG_CODE, psDescription,
                                 case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                                 nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_POPULATION_CATEGORY(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                                 pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_POPULATION_CATEGORY;
--
-- ----------------------------------------
-- DELETE_POPULATION_CATEGORY
-- ----------------------------------------
--
  procedure DELETE_POPULATION_CATEGORY
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in P_BASE.tnPOPC_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPOPC_VERSION_NBR;
    xPOPC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_POPULATION_CATEGORY',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPOPC_ROWID
    from T_POPULATION_CATEGORIES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPULATION_CATEGORIES where rowid = xPOPC_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('POPC', 1, 'Population category has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_POPULATION_CATEGORY;
--
-- ----------------------------------------
-- SET_POPC_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_POPC_DESCRIPTION
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in out P_BASE.tnPOPC_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPC_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_POPC_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_POPC_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_POPC_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_POPC_DESCRIPTION
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in out P_BASE.tnPOPC_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_POPC_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_POPC_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_POPC_DESCRIPTION;
--
-- ----------------------------------------
-- SET_POPC_TEXT
-- ----------------------------------------
--
  procedure SET_POPC_TEXT
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in out P_BASE.tnPOPC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPOPC_VERSION_NBR;
    xPOPC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPC_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPOPC_ROWID
    from T_POPULATION_CATEGORIES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'POPC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPULATION_CATEGORIES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPOPC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('POPC', 1, 'Population category has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_POPC_TEXT;
--
-- ----------------------------------------
-- REMOVE_POPC_TEXT
-- ----------------------------------------
--
  procedure REMOVE_POPC_TEXT
   (psCODE in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in out P_BASE.tnPOPC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPOPC_VERSION_NBR;
    xPOPC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_POPC_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPOPC_ROWID
    from T_POPULATION_CATEGORIES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPULATION_CATEGORIES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPOPC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('POPC', 1, 'Population category has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_POPC_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'POPC'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_POPULATION_CATEGORY;
/

show errors
