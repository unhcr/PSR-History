create or replace package body TEXT_TYPE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_TEXT_TYPE
-- ----------------------------------------
--
  procedure INSERT_TEXT_TYPE
   (psCODE in TEXT_TYPES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2,
    pnDISPLAY_SEQ in TEXT_TYPES.DISPLAY_SEQ%type := null,
    psACTIVE_FLAG in TEXT_TYPES.ACTIVE_FLAG%type := 'Y')
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.INSERT_TEXT_TYPE',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    TEXT.INSERT_TEXT(nTXT_ID, 'LANG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into TEXT_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_TEXT_TYPE;
--
-- ----------------------------------------
-- UPDATE_TEXT_TYPE
-- ----------------------------------------
--
  procedure UPDATE_TEXT_TYPE
   (psCODE in TEXT_TYPES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psDescription in varchar2 := null,
    pnDISPLAY_SEQ in TEXT_TYPES.DISPLAY_SEQ%type := -1e6,
    psACTIVE_FLAG in TEXT_TYPES.ACTIVE_FLAG%type := null)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_TEXT_TYPE',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    if psDescription is not null
    then
      if psLANG_CODE is null
      then MESSAGE.DISPLAY_MESSAGE('TXTT', 1, 'en', 'Description language must be specified');
      end if;
    --
      begin
        select ACTIVE_FLAG into sActive from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('TXTT', 2, 'en', 'Unknown description language');
      end;
    --
      if sActive = 'N'
      then MESSAGE.DISPLAY_MESSAGE('TXTT', 3, 'en', 'Inactive description language');
      end if;
    --
      select TXT_ID into nTXT_ID from TEXT_TYPES where CODE = psCODE;
    --
      TEXT.UPDATE_TEXT(nTXT_ID, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
    --
    elsif psLANG_CODE is not null
    then MESSAGE.DISPLAY_MESSAGE('TXTT', 5, 'en', 'Description language cannot be specified without description text');
    elsif pnDISPLAY_SEQ = -1e6
      and psACTIVE_FLAG is null
    then MESSAGE.DISPLAY_MESSAGE('TXTT', 6, 'en', 'Nothing to be updated');
    end if;
  --
    if nvl(pnDISPLAY_SEQ, 0) != -1e6
      or psACTIVE_FLAG is not null
    then
      update TEXT_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG)
      where CODE = psCODE;
    --
      if sql%rowcount = 0
      then MESSAGE.DISPLAY_MESSAGE('TXTT', 4, 'en', 'Text type does not exist');
      end if;
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_TEXT_TYPE;
--
-- ----------------------------------------
-- ADD_TXTT_DESCRIPTION
-- ----------------------------------------
--
  procedure ADD_TXTT_DESCRIPTION
   (psCODE in TEXT_TYPES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2)
  is
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.ADD_TXTT_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    ADD_TXTT_TEXT(psCODE, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end ADD_TXTT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_TXTT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_TXTT_DESCRIPTION
   (psCODE in TEXT_TYPES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_TXTT_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE);
  --
    REMOVE_TXTT_TEXT(psCODE, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_TXTT_DESCRIPTION;
--
-- ----------------------------------------
-- ADD_TXTT_TEXT
-- ----------------------------------------
--
  procedure ADD_TXTT_TEXT
   (psCODE in TEXT_TYPES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    sActive varchar2(1);
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.ADD_TXTT_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from TEXT_TYPES where CODE = psCODE;
  --
    TEXT.INSERT_TEXT(nTXT_ID, null, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end ADD_TXTT_TEXT;
--
-- ----------------------------------------
-- UPDATE_TXTT_TEXT
-- ----------------------------------------
--
  procedure UPDATE_TXTT_TEXT
   (psCODE in TEXT_TYPES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_TXTT_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from TEXT_TYPES where CODE = psCODE;
  --
    TEXT.UPDATE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_TXTT_TEXT;
--
-- ----------------------------------------
-- REMOVE_TXTT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_TXTT_TEXT
   (psCODE in TEXT_TYPES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_TXTT_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID into nTXT_ID from TEXT_TYPES where CODE = psCODE;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('TXTT', 7, 'en', 'Text type must be specified');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_TXTT_TEXT;
--
-- ----------------------------------------
-- DELETE_TEXT_TYPE
-- ----------------------------------------
--
  procedure DELETE_TEXT_TYPE
   (psCODE in TEXT_TYPES.CODE%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_TEXT_TYPE', psCODE);
  --
    delete from TEXT_TYPES where CODE = psCODE returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('TXTT', 4, 'en', 'Text type does not exist');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_TEXT_TYPE;
--
-- ----------------------------------------
-- SET_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure SET_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in TEXT_TYPE_PROPERTIES.TXTT_CODE%type,
    psTAB_ALIAS in TEXT_TYPE_PROPERTIES.TAB_ALIAS%type,
    psMANDATORY in TEXT_TYPE_PROPERTIES.MANDATORY%type := null,
    psMULTI_INSTANCE in TEXT_TYPE_PROPERTIES.MULTI_INSTANCE%type := null)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_TEXT_TYPE_PROPERTIES',
                             psTXTT_CODE || '~' || psTAB_ALIAS || '~' ||
                               psMANDATORY || '~' || psMULTI_INSTANCE);
  --
    merge into TEXT_TYPE_PROPERTIES TTP
    using
     (select psTXTT_CODE TXTT_CODE, psTAB_ALIAS TAB_ALIAS from DUAL) INP
    on (TTP.TXTT_CODE = INP.TXTT_CODE and TTP.TAB_ALIAS = INP.TAB_ALIAS)
    when matched then
      update
      set MANDATORY = nvl(psMANDATORY, MANDATORY),
        MULTI_INSTANCE = nvl(psMULTI_INSTANCE, MULTI_INSTANCE)
    when not matched then
      insert (TXTT_CODE, TAB_ALIAS, MANDATORY, MULTI_INSTANCE)
      values (psTXTT_CODE, psTAB_ALIAS, nvl(psMANDATORY, 'N'), nvl(psMULTI_INSTANCE, 'Y'));
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_TEXT_TYPE_PROPERTIES;
--
-- ----------------------------------------
-- REMOVE_TEXT_TYPE_PROPERTIES
-- ----------------------------------------
--
  procedure REMOVE_TEXT_TYPE_PROPERTIES
   (psTXTT_CODE in TEXT_TYPE_PROPERTIES.TXTT_CODE%type,
    psTAB_ALIAS in TEXT_TYPE_PROPERTIES.TAB_ALIAS%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_TEXT_TYPE_PROPERTIES',
                             psTXTT_CODE || '~' || psTAB_ALIAS);
  --
    delete from TEXT_TYPE_PROPERTIES where TXTT_CODE = psTXTT_CODE and TAB_ALIAS = psTAB_ALIAS;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('TXTT', 9, 'en', 'Text type property does not exist');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_TEXT_TYPE_PROPERTIES;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'TEXT_TYPE'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'en', 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'en', 'Module version mismatch');
  end if;
--
end TEXT_TYPE;
/

show errors
