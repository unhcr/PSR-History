create or replace package body P_DISPLACEMENT_STATUS is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure INSERT_DISPLACEMENT_STATUS
   (psCODE in P_BASE.tmsDST_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnDST_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsDST_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_DISPLACEMENT_STATUS',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'DST', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_DISPLACEMENT_STATUSES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- UPDATE_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure UPDATE_DISPLACEMENT_STATUS
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnDST_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDST_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_DISPLACEMENT_STATUS',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'DST', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_DISPLACEMENT_STATUSES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xDST_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DST', 1, 'Displacement status has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- SET_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure SET_DISPLACEMENT_STATUS
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnDST_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsDST_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DISPLACEMENT_STATUS',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_DISPLACEMENT_STATUS(psCODE, psLANG_CODE, psDescription,
                                 case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                                 nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_DISPLACEMENT_STATUS(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                                 pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- DELETE_DISPLACEMENT_STATUS
-- ----------------------------------------
--
  procedure DELETE_DISPLACEMENT_STATUS
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in P_BASE.tnDST_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_DISPLACEMENT_STATUS',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_DISPLACEMENT_STATUSES where rowid = xDST_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('DST', 1, 'Displacement status has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_DISPLACEMENT_STATUS;
--
-- ----------------------------------------
-- SET_DST_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_DST_DESCRIPTION
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DST_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_DST_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DST_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_DST_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_DST_DESCRIPTION
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_DST_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_DST_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_DST_DESCRIPTION;
--
-- ----------------------------------------
-- SET_DST_TEXT
-- ----------------------------------------
--
  procedure SET_DST_TEXT
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_DST_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'DST', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_DISPLACEMENT_STATUSES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDST_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DST', 1, 'Displacement status has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_DST_TEXT;
--
-- ----------------------------------------
-- REMOVE_DST_TEXT
-- ----------------------------------------
--
  procedure REMOVE_DST_TEXT
   (psCODE in P_BASE.tmsDST_CODE,
    pnVERSION_NBR in out P_BASE.tnDST_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnDST_VERSION_NBR;
    xDST_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_DST_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xDST_ROWID
    from T_DISPLACEMENT_STATUSES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_DISPLACEMENT_STATUSES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xDST_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('DST', 1, 'Displacement status has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_DST_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'DST'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_DISPLACEMENT_STATUS;
/

show errors
