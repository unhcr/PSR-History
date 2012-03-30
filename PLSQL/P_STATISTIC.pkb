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
    pnLOC_CODE in P_BASE.tmnLOC_CODE,
    pnLOC_CODE_COUNTRY in P_BASE.tmnLOC_CODE,
    psCOUNTRY_CODE in P_BASE.tmsLOC_COUNTRY_CODE,
    pnLOC_CODE_ORIGIN in P_BASE.tnLOC_CODE := null,
    pnLOC_CODE_COUNTRY_ORIGIN in P_BASE.tnLOC_CODE := null,
    psCOUNTRY_CODE_ORIGIN in P_BASE.tsLOC_COUNTRY_CODE := null,
    pnLOC_CODE_PPG in P_BASE.tnLOC_CODE := null,
    psPPG_CODE in P_BASE.tsPPG_CODE := null,
    pdPPG_START_DATE in P_BASE.tdDate := null,
    psPOPC_CODE in P_BASE.tsPOPC_CODE := null,
    pdPER_START_DATE in P_BASE.tdDate := null,
    pdPER_END_DATE in P_BASE.tdDate := null,
    psSEX in P_BASE.tsSTC_SEX := null,
    psAGP_CODE in P_BASE.tsAGP_CODE := null,
    pnAGE_FROM in P_BASE.tnAGR_AGE_FROM := null,
    pnAGE_TO in P_BASE.tnAGR_AGE_TO := null,
    pnVALUE in P_BASE.tmnSTC_VALUE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_STATISTIC',
      psSTCT_CODE || '~' ||
        to_char(pnLOC_CODE) || '~' ||
        to_char(pnLOC_CODE_COUNTRY) || '~' || psCOUNTRY_CODE || '~' ||
        to_char(pnLOC_CODE_ORIGIN) || '~' ||
        to_char(pnLOC_CODE_COUNTRY_ORIGIN) || '~' || psCOUNTRY_CODE_ORIGIN || '~' ||
        to_char(pnLOC_CODE_PPG) || '~' || psPPG_CODE || '~' ||
        to_char(pdPPG_START_DATE, 'YYYY-MM-DD') || '~' ||
        psPOPC_CODE || '~' ||
        to_char(pdPER_START_DATE, 'YYYY-MM-DD') || '~' ||
        to_char(pdPER_END_DATE, 'YYYY-MM-DD') || '~' ||
        psSEX || '~' ||
        psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnAGE_TO) || '~' ||
        to_char(pnVALUE));
  --
    insert into STATISTICS
     (ID,
      STCT_CODE,
      LOC_CODE,
      LOC_CODE_COUNTRY, COUNTRY_CODE,
      LOC_CODE_ORIGIN,
      LOC_CODE_COUNTRY_ORIGIN, COUNTRY_CODE_ORIGIN,
      LOC_CODE_PPG, PPG_CODE, PPG_START_DATE,
      POPC_CODE,
      PER_START_DATE, PER_END_DATE,
      SEX,
      AGP_CODE, AGE_FROM, AGE_TO,
      VALUE)
    values
     (STC_SEQ.nextval,
      psSTCT_CODE,
      pnLOC_CODE,
      pnLOC_CODE_COUNTRY, psCOUNTRY_CODE,
      pnLOC_CODE_ORIGIN,
      pnLOC_CODE_COUNTRY_ORIGIN, psCOUNTRY_CODE_ORIGIN,
      pnLOC_CODE_PPG, psPPG_CODE, pdPPG_START_DATE,
      psPOPC_CODE,
      pdPER_START_DATE, pdPER_END_DATE,
      psSEX,
      psAGP_CODE, pnAGE_FROM, pnAGE_TO,
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
   (pnID in P_BASE.tmsPOPC_CODE,
    pnVERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_STATISTIC',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTC_ROWID
    from STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from STATISTICS where rowid = xSTC_ROWID;
    --
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID);
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
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_STC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTC_ROWID
    from STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'STC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update STATISTICS
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
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnSTC_VERSION_NBR;
    xSTC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_STC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSTC_ROWID
    from STATISTICS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
      end if;
    --
      update STATISTICS
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
