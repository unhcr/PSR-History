create or replace package body P_ORIGIN is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_ORIGIN
-- ----------------------------------------
--
  procedure INSERT_ORIGIN
   (psCODE in P_BASE.tmsOGN_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText,
    pnLOC_CODE in P_BASE.tnLOC_CODE := null,
    psACTIVE_FLAG in P_BASE.tmsOGN_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_ORIGIN',
      psCODE || '~' || to_char(pnLOC_CODE) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'OGN', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    insert into ORIGINS (CODE, LOC_CODE, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnLOC_CODE, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_ORIGIN;
--
-- ----------------------------------------
-- UPDATE_ORIGIN
-- ----------------------------------------
--
  procedure UPDATE_ORIGIN
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in out P_BASE.tnOGN_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    pnLOC_CODE in P_BASE.tnLOC_CODE := -1,
    psACTIVE_FLAG in P_BASE.tsOGN_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnOGN_VERSION_NBR;
    xOGN_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_ORIGIN',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnLOC_CODE) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xOGN_ROWID
    from ORIGINS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psName is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'OGN', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
      end if;
    --
      update ORIGINS
      set LOC_CODE = case when pnLOC_CODE = -1 then LOC_CODE else pnLOC_CODE end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xOGN_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('OGN', 1, 'Origin has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_ORIGIN;
--
-- ----------------------------------------
-- SET_ORIGIN
-- ----------------------------------------
--
  procedure SET_ORIGIN
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in out P_BASE.tnOGN_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    pnLOC_CODE in P_BASE.tnLOC_CODE := -1,
    psACTIVE_FLAG in P_BASE.tsOGN_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_ORIGIN',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnLOC_CODE) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    if pnVERSION_NBR is null
    then
      INSERT_ORIGIN(psCODE, psLANG_CODE, psName,
                    case when pnLOC_CODE = -1 then null else pnLOC_CODE end,
                    nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_ORIGIN(psCODE, pnVERSION_NBR, psLANG_CODE, psName, pnLOC_CODE, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_ORIGIN;
--
-- ----------------------------------------
-- DELETE_ORIGIN
-- ----------------------------------------
--
  procedure DELETE_ORIGIN
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in P_BASE.tnOGN_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnOGN_VERSION_NBR;
    xOGN_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_ORIGIN',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xOGN_ROWID
    from ORIGINS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from ORIGINS where rowid = xOGN_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('OGN', 1, 'Origin has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_ORIGIN;
--
-- ----------------------------------------
-- SET_OGN_NAME
-- ----------------------------------------
--
  procedure SET_OGN_NAME
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in out P_BASE.tnOGN_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_OGN_NAME',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    SET_OGN_TEXT(psCODE, pnVERSION_NBR, 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_OGN_NAME;
--
-- ----------------------------------------
-- REMOVE_OGN_NAME
-- ----------------------------------------
--
  procedure REMOVE_OGN_NAME
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in out P_BASE.tnOGN_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_OGN_NAME',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_OGN_TEXT(psCODE, pnVERSION_NBR, 'NAME', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_OGN_NAME;
--
-- ----------------------------------------
-- SET_OGN_TEXT
-- ----------------------------------------
--
  procedure SET_OGN_TEXT
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in out P_BASE.tnOGN_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnOGN_VERSION_NBR;
    xOGN_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_OGN_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xOGN_ROWID
    from ORIGINS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'OGN', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update ORIGINS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xOGN_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('OGN', 1, 'Origin has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_OGN_TEXT;
--
-- ----------------------------------------
-- REMOVE_OGN_TEXT
-- ----------------------------------------
--
  procedure REMOVE_OGN_TEXT
   (psCODE in P_BASE.tmsOGN_CODE,
    pnVERSION_NBR in out P_BASE.tnOGN_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnOGN_VERSION_NBR;
    xOGN_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_OGN_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xOGN_ROWID
    from ORIGINS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update ORIGINS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xOGN_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('OGN', 1, 'Origin has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_OGN_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'OGN'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_ORIGIN;
/

show errors
