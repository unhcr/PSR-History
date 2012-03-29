create or replace package body P_TIME_PERIOD is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_TIME_PERIOD_TYPE
-- ----------------------------------------
--
  procedure INSERT_TIME_PERIOD_TYPE
   (psCODE in P_BASE.tmsPERT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnPERT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsPERT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_TIME_PERIOD_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'PERT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into TIME_PERIOD_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_TIME_PERIOD_TYPE;
--
-- ----------------------------------------
-- UPDATE_TIME_PERIOD_TYPE
-- ----------------------------------------
--
  procedure UPDATE_TIME_PERIOD_TYPE
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in out P_BASE.tnPERT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPERT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPERT_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPERT_VERSION_NBR;
    xPERT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_TIME_PERIOD_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPERT_ROWID
    from TIME_PERIOD_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'PERT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update TIME_PERIOD_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPERT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 1, 'Time period type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_TIME_PERIOD_TYPE;
--
-- ----------------------------------------
-- SET_TIME_PERIOD_TYPE
-- ----------------------------------------
--
  procedure SET_TIME_PERIOD_TYPE
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in out P_BASE.tnPERT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPERT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPERT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TIME_PERIOD_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_TIME_PERIOD_TYPE(psCODE, psLANG_CODE, psDescription,
                              case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                              nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_TIME_PERIOD_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                              pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TIME_PERIOD_TYPE;
--
-- ----------------------------------------
-- DELETE_TIME_PERIOD_TYPE
-- ----------------------------------------
--
  procedure DELETE_TIME_PERIOD_TYPE
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in P_BASE.tnPERT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPERT_VERSION_NBR;
    xPERT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_TIME_PERIOD_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPERT_ROWID
    from TIME_PERIOD_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from TIME_PERIOD_TYPES where rowid = xPERT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 1, 'Time period type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_TIME_PERIOD_TYPE;
--
-- ----------------------------------------
-- SET_PERT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PERT_DESCRIPTION
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in out P_BASE.tnPERT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PERT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PERT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PERT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PERT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PERT_DESCRIPTION
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in out P_BASE.tnPERT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PERT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_PERT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PERT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PERT_TEXT
-- ----------------------------------------
--
  procedure SET_PERT_TEXT
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in out P_BASE.tnPERT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPERT_VERSION_NBR;
    xPERT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PERT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPERT_ROWID
    from TIME_PERIOD_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'PERT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update TIME_PERIOD_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPERT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 1, 'Time period type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PERT_TEXT;
--
-- ----------------------------------------
-- REMOVE_PERT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PERT_TEXT
   (psCODE in P_BASE.tmsPERT_CODE,
    pnVERSION_NBR in out P_BASE.tnPERT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPERT_VERSION_NBR;
    xPERT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PERT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPERT_ROWID
    from TIME_PERIOD_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update TIME_PERIOD_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPERT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 1, 'Time period type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PERT_TEXT;
--
-- ----------------------------------------
-- INSERT_TIME_PERIOD
-- ----------------------------------------
--
  procedure INSERT_TIME_PERIOD
   (pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
    psPERT_CODE in P_BASE.tmsPERT_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_TIME_PERIOD',
      to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || psPERT_CODE);
  --
    insert into TIME_PERIODS (START_DATE, END_DATE, PERT_CODE)
    values (pdSTART_DATE, pdEND_DATE, psPERT_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_TIME_PERIOD;
--
-- ----------------------------------------
-- DELETE_TIME_PERIOD
-- ----------------------------------------
--
  procedure DELETE_TIME_PERIOD
   (pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnPER_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPER_VERSION_NBR;
    xPER_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_TIME_PERIOD',
      to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPER_ROWID
    from TIME_PERIODS
    where START_DATE = pdSTART_DATE
    and END_DATE = pdEND_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from TIME_PERIODS where rowid = xPER_ROWID;
    --
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 2, 'Time period has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_TIME_PERIOD;
--
-- ----------------------------------------
-- SET_PER_TEXT
-- ----------------------------------------
--
  procedure SET_PER_TEXT
   (pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPER_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPER_VERSION_NBR;
    xPER_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PER_TEXT',
      to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPER_ROWID
    from TIME_PERIODS
    where START_DATE = pdSTART_DATE
    and END_DATE = pdEND_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'PER', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update TIME_PERIODS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPER_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 2, 'Time period has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PER_TEXT;
--
-- ----------------------------------------
-- REMOVE_PER_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PER_TEXT
   (pdSTART_DATE in P_BASE.tmdDate,
    pdEND_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPER_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPER_VERSION_NBR;
    xPER_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PER_TEXT',
      to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPER_ROWID
    from TIME_PERIODS
    where START_DATE = pdSTART_DATE
    and END_DATE = pdEND_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update TIME_PERIODS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPER_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PER', 2, 'Time period has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PER_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'PER'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_TIME_PERIOD;
/

show errors
