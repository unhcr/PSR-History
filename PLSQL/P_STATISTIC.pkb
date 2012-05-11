create or replace package body P_STATISTIC is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_STATISTIC
-- ----------------------------------------
--
  procedure INSERT_STATISTIC
   (pnID out P_BASE.tnSTC_ID,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnLOC_ID_COUNTRY in P_BASE.tmnLOC_ID,
    pnLOC_ID_ASYLUM in P_BASE.tmnLOC_ID,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnLOC_ID_SOURCE in P_BASE.tnLOC_ID := null,
    pnPPG_ID in P_BASE.tnPPG_ID := null,
    psDST_CODE in P_BASE.tsDST_CODE := null,
    pnPER_ID in P_BASE.tnPER_ID := null,
    psSEX_CODE in P_BASE.tsSEX_CODE := null,
    pnAGR_ID in P_BASE.tnAGR_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    pnVALUE in P_BASE.tmnSTC_VALUE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC',
      psSTCT_CODE || '~' ||
        to_char(pnLOC_ID_COUNTRY) || '~' ||
        to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnLOC_ID_SOURCE) || '~' ||
        to_char(pnPPG_ID) || '~' ||
        psDST_CODE || '~' ||
        to_char(pnPER_ID) || '~' ||
        psSEX_CODE || '~' ||
        to_char(pnDIM_ID1) || '~' ||
        to_char(pnDIM_ID2) || '~' ||
        to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' ||
        to_char(pnDIM_ID5) || '~' ||
        to_char(pnVALUE));
  --
    insert into T_STATISTICS
     (ID, STCT_CODE,
      LOC_ID_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN, LOC_ID_SOURCE,
      PPG_ID, DST_CODE, PER_ID, SEX_CODE, AGR_ID,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5,
      VALUE)
    values
     (STC_SEQ.nextval, psSTCT_CODE,
      pnLOC_ID_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN, pnLOC_ID_SOURCE,
      pnPPG_ID, psDST_CODE, pnPER_ID, psSEX_CODE, pnAGR_ID,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5,
      pnVALUE)
    returning ID into pnID;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_STATISTIC;
--
-- ----------------------------------------
-- DELETE_STATISTIC
-- ----------------------------------------
--
  procedure DELETE_STATISTIC
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STATISTICS where rowid = xSTC_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STC', 1, 'Statistic has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_STATISTIC;
--
-- ----------------------------------------
-- SET_STC_TEXT
-- ----------------------------------------
--
  procedure SET_STC_TEXT
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STATISTICS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STC', 1, 'Statistic has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_STC_TEXT;
--
-- ----------------------------------------
-- REMOVE_STC_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STC_TEXT
   (pnID in P_BASE.tmnSTC_ID,
    pnVERSION_NBR in out P_BASE.tnSTC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTC_ROWID
    from T_STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
      end if;
    --
      update T_STATISTICS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('STC', 1, 'Statistic has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_STC_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'STC'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_STATISTIC;
/

show errors
