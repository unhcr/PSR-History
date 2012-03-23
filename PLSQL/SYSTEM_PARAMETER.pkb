create or replace package body SYSTEM_PARAMETER is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure INSERT_SYSTEM_PARAMETER
   (psCODE in tmsSYP_CODE,
    psDATA_TYPE in tmsSYP_DATA_TYPE,
    psCHAR_VALUE in tsSYP_CHAR_VALUE := null,
    pnNUM_VALUE in tnSYP_NUM_VALUE := null,
    pdDATE_VALUE in tdSYP_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_SYSTEM_PARAMETER',
      psCODE || '~' || psDATA_TYPE || '~' || psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    insert into SYSTEM_PARAMETERS (CODE, DATA_TYPE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (psCODE, psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- UPDATE_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure UPDATE_SYSTEM_PARAMETER
   (psCODE in tmsSYP_CODE,
    pnVERSION_NBR in out tnSYP_VERSION_NBR,
    psDATA_TYPE in tmsSYP_DATA_TYPE,
    psCHAR_VALUE in tsSYP_CHAR_VALUE := null,
    pnNUM_VALUE in tnSYP_NUM_VALUE := null,
    pdDATE_VALUE in tdSYP_DATE_VALUE := null)
  is
    nVERSION_NBR tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_SYSTEM_PARAMETER',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xSYP_ROWID
    from SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update SYSTEM_PARAMETERS
      set DATA_TYPE = psDATA_TYPE,
        CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSYP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('SYP', 1, 'System parameter has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- SET_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure SET_SYSTEM_PARAMETER
   (psCODE in tmsSYP_CODE,
    pnVERSION_NBR in out tnSYP_VERSION_NBR,
    psDATA_TYPE in tmsSYP_DATA_TYPE,
    psCHAR_VALUE in tsSYP_CHAR_VALUE := null,
    pnNUM_VALUE in tnSYP_NUM_VALUE := null,
    pdDATE_VALUE in tdSYP_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_SYSTEM_PARAMETER',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_SYSTEM_PARAMETER(psCODE, psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_SYSTEM_PARAMETER(psCODE, pnVERSION_NBR, psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE,
                              pdDATE_VALUE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- DELETE_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure DELETE_SYSTEM_PARAMETER
   (psCODE in tmsSYP_CODE,
    pnVERSION_NBR in tnSYP_VERSION_NBR)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_SYSTEM_PARAMETER',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSYP_ROWID
    from SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from SYSTEM_PARAMETERS where rowid = xSYP_ROWID;
    --
      if nTXT_ID is not null
      then TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      MESSAGE.DISPLAY_MESSAGE('SYP', 1, 'System parameter has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- SET_SYP_TEXT
-- ----------------------------------------
--
  procedure SET_SYP_TEXT
   (psCODE in tmsSYP_CODE,
    pnVERSION_NBR in out tnSYP_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in out tnTXI_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psText in tmsText)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_SYP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSYP_ROWID
    from SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.SET_TEXT(nTXT_ID, 'SYP', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update SYSTEM_PARAMETERS
      set TXT_ID = nTXT_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSYP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('SYP', 1, 'System parameter has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_SYP_TEXT;
--
-- ----------------------------------------
-- REMOVE_SYP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_SYP_TEXT
   (psCODE in tmsSYP_CODE,
    pnVERSION_NBR in out tnSYP_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in tnTXI_SEQ_NBR := null,
    psLANG_CODE in tsLANG_CODE := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnSYP_VERSION_NBR;
    xSYP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_SYP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xSYP_ROWID
    from SYSTEM_PARAMETERS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update SYSTEM_PARAMETERS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSYP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('SYP', 1, 'System parameter has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_SYP_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'SYSTEM_PARAMETER'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end SYSTEM_PARAMETER;
/

show errors
