create or replace package body LANGUAGE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_LANGUAGE
-- ----------------------------------------
--
  procedure SET_LANGUAGE
   (psCODE in LANGUAGES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psDescription in varchar2 := null,
    pnDISPLAY_SEQ in LANGUAGES.DISPLAY_SEQ%type := -1e6,
    psACTIVE_FLAG in LANGUAGES.ACTIVE_FLAG%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
    sActive varchar2(1);
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_LANGUAGE',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check if language already exists.
  --
    begin
      select TXT_ID into nTXT_ID from LANGUAGES where CODE = psCODE;
    exception
      when NO_DATA_FOUND
      then nTXT_ID := null;
        nSEQ_NBR := null;
    end;
  --
    if psDescription is null
    then
      if nTXT_ID is null
      then MESSAGE.DISPLAY_MESSAGE('LANG', 1, 'en', 'Description must be specified for new language');
      elsif psLANG_CODE is not null
      then MESSAGE.DISPLAY_MESSAGE('LANG', 2, 'en', 'Description language cannot be specified without description text');
      elsif pnDISPLAY_SEQ = -1e6
        and psACTIVE_FLAG is null
      then MESSAGE.DISPLAY_MESSAGE('LANG', 3, 'en', 'Nothing to be updated');
      end if;
    else
      begin
        select ACTIVE_FLAG into sActive from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('LANG', 4, 'en', 'Unknown description language');
      end;
    --
      if sActive = 'N'
      then MESSAGE.DISPLAY_MESSAGE('LANG', 5, 'en', 'Inactive description language');
      end if;
    --
      TEXT.SET_TEXT(nTXT_ID, 'LANG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
    end if;
  --
    merge into LANGUAGES LANG
    using
     (select psCODE CODE from DUAL) INP
    on (LANG.CODE = INP.CODE)
    when matched then
      update
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG)
      where nvl(pnDISPLAY_SEQ, 0) != -1e6
        or psACTIVE_FLAG is not null
    when not matched then
      insert
       (CODE, DISPLAY_SEQ, ACTIVE_FLAG,
        TXT_ID)
      values
       (psCODE, case when pnDISPLAY_SEQ != -1e6 then pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'),
        nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LANGUAGE;
--
-- ----------------------------------------
-- DELETE_LANGUAGE
-- ----------------------------------------
--
  procedure DELETE_LANGUAGE
   (psCODE in LANGUAGES.CODE%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_LANGUAGE', psCODE);
  --
    delete from LANGUAGES where CODE = psCODE returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('LANG', 6, 'en', 'Language does not exist');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_LANGUAGE;
--
-- ----------------------------------------
-- SET_LANG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LANG_DESCRIPTION
   (psCODE in LANGUAGES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2)
  is
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_LANG_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LANG_TEXT(psCODE, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LANG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LANG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LANG_DESCRIPTION
   (psCODE in LANGUAGES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_LANG_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE);
  --
    REMOVE_LANG_TEXT(psCODE, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LANG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LANG_TEXT
-- ----------------------------------------
--
  procedure SET_LANG_TEXT
   (psCODE in LANGUAGES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_LANG_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from LANGUAGES where CODE = psCODE;
  --
    TEXT.SET_TEXT(nTXT_ID, null, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LANG_TEXT;
--
-- ----------------------------------------
-- REMOVE_LANG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LANG_TEXT
   (psCODE in LANGUAGES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_LANG_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnTXI_SEQ_NBR) || '~' || psLANG_CODE);
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('LANG', 7, 'en', 'Text type must be specified');
    end if;
  --
    select TXT_ID into nTXT_ID from LANGUAGES where CODE = psCODE;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LANG_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'LANGUAGE'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'en', 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'en', 'Module version mismatch');
  end if;
--
end LANGUAGE;
/

show errors
