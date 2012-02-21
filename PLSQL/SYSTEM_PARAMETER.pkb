create or replace package body SYSTEM_PARAMETER is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure SET_SYSTEM_PARAMETER
   (psCODE in SYSTEM_PARAMETERS.CODE%type,
    psDATA_TYPE in SYSTEM_PARAMETERS.DATA_TYPE%type,
    psCHAR_VALUE in SYSTEM_PARAMETERS.CHAR_VALUE%type := null,
    pnNUM_VALUE in SYSTEM_PARAMETERS.NUM_VALUE%type := null,
    pdDATE_VALUE in SYSTEM_PARAMETERS.DATE_VALUE%type := null)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_SYSTEM_PARAMETER',
                             psCODE || '~' || psDATA_TYPE || '~' ||
                             psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
                             to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    merge into SYSTEM_PARAMETERS SYP
    using
     (select psCODE CODE from DUAL) INP
    on (SYP.CODE = INP.CODE)
    when matched then
      update
      set DATA_TYPE = psDATA_TYPE,
        CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE
    when not matched then
      insert
       (CODE, DATA_TYPE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
      values
       (psCODE, psDATA_TYPE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- DELETE_SYSTEM_PARAMETER
-- ----------------------------------------
--
  procedure DELETE_SYSTEM_PARAMETER
   (psCODE in SYSTEM_PARAMETERS.CODE%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_SYSTEM_PARAMETER', psCODE);
  --
    delete from SYSTEM_PARAMETERS where CODE = psCODE returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('SYP', 1, 'en', 'System parameter does not exist');
    end if;
  --
    if nTXT_ID is not null
    then TEXT.DELETE_TEXT(nTXT_ID);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_SYSTEM_PARAMETER;
--
-- ----------------------------------------
-- SET_SYP_TEXT
-- ----------------------------------------
--
  procedure SET_SYP_TEXT
   (psCODE in SYSTEM_PARAMETERS.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    xSYP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_SYP_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, rowid into nTXT_ID, xSYP_ROWID from SYSTEM_PARAMETERS where CODE = psCODE;
  --
    if nTXT_ID is null
    then
      TEXT.SET_TEXT(nTXT_ID, 'SYP', psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
    --
      update SYSTEM_PARAMETERS set TXT_ID = nTXT_ID where rowid = xSYP_ROWID;
    else
      TEXT.SET_TEXT(nTXT_ID, 'SYP', psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_SYP_TEXT;
--
-- ----------------------------------------
-- REMOVE_SYP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_SYP_TEXT
   (psCODE in SYSTEM_PARAMETERS.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_SYP_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE);
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('SYP', 2, 'en', 'Text type must be specified');
    end if;
  --
    select TXT_ID into nTXT_ID from SYSTEM_PARAMETERS where CODE = psCODE;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_SYP_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'SYSTEM_PARAMETER'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'en', 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'en', 'Module version mismatch');
  end if;
--
end SYSTEM_PARAMETER;
/

show errors
