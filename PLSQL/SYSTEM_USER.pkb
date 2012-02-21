create or replace package body SYSTEM_USER is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_SYSTEM_USER
-- ----------------------------------------
--
  procedure SET_SYSTEM_USER
   (psUSERID in SYSTEM_USERS.USERID%type,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psName in varchar2 := null,
    psLOCKED_FLAG in SYSTEM_USERS.LOCKED_FLAG%type := null,
    psTEMPLATE_FLAG in SYSTEM_USERS.TEMPLATE_FLAG%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
    sACTIVE_FLAG LANGUAGES.ACTIVE_FLAG%type;
    nMSG_SEQ_NBR_MAX COMPONENTS.MSG_SEQ_NBR_MAX%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_SYSTEM_USER',
                             psUSERID || '~' || psLOCKED_FLAG || '~' ||
                               psTEMPLATE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psName)) || ':' || psName);
  --
  -- Check if system user already exists.
  --
    begin
      select TXT_ID into nTXT_ID from SYSTEM_USERS where USERID = psUSERID;
    exception
      when NO_DATA_FOUND
      then nTXT_ID := null;
        nTXI_SEQ_NBR := null;
    end;
  --
    if psName is null
    then
      if nTXT_ID is null
      then MESSAGE.DISPLAY_MESSAGE('USR', 8, 'en', 'Name must be specified for new user');
      elsif psLANG_CODE is not null
      then MESSAGE.DISPLAY_MESSAGE('USR', 9, 'en', 'Name language cannot be specified without name');
      elsif psLOCKED_FLAG is null
        and psTEMPLATE_FLAG is null
      then MESSAGE.DISPLAY_MESSAGE('USR', 3, 'en', 'Nothing to be updated');
      end if;
    else
      begin
        select ACTIVE_FLAG into sACTIVE_FLAG from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('USR', 10, 'en', 'Unknown name language');
      end;
    --
      if sACTIVE_FLAG = 'N'
      then MESSAGE.DISPLAY_MESSAGE('USR', 11, 'en', 'Inactive name language');
      end if;
    --
      TEXT.SET_TEXT(nTXT_ID, 'USR', 'NAME', nTXI_SEQ_NBR, psLANG_CODE, psName);
    end if;
  --
    merge into SYSTEM_USERS USR
    using
     (select psUSERID USERID from DUAL) INP
    on (USR.USERID = INP.USERID)
    when matched then
      update
      set LOCKED_FLAG = nvl(psLOCKED_FLAG, LOCKED_FLAG),
         TEMPLATE_FLAG = nvl(psTEMPLATE_FLAG, TEMPLATE_FLAG)
      where psLOCKED_FLAG is not null
        or psTEMPLATE_FLAG is not null
    when not matched then
      insert (USERID, LOCKED_FLAG, TEMPLATE_FLAG, TXT_ID)
      values (psUSERID, nvl(psLOCKED_FLAG, 'N'), nvl(psTEMPLATE_FLAG, 'N'), nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_SYSTEM_USER;
--
-- ----------------------------------------
-- DELETE_SYSTEM_USER
-- ----------------------------------------
--
  procedure DELETE_SYSTEM_USER
   (psUSERID in SYSTEM_USERS.USERID%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_SYSTEM_USER',
                             psUSERID);
  --
    delete from SYSTEM_USERS
    where USERID = psUSERID
    returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('USR', 12, 'en', 'User does not exist');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_SYSTEM_USER;
--
-- ----------------------------------------
-- SET_USR_NAME
-- ----------------------------------------
--
  procedure SET_USR_NAME
   (psUSERID in SYSTEM_USERS.USERID%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psName in varchar2)
  is
    nTXI_SEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_USR_NAME',
                             psUSERID || '~' || psLANG_CODE || '~' ||
                               to_char(length(psName)) || ':' || psName);
  --
    SET_USR_TEXT(psUSERID, 'NAME', nTXI_SEQ_NBR, psLANG_CODE, psName);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_USR_NAME;
--
-- ----------------------------------------
-- REMOVE_USR_NAME
-- ----------------------------------------
--
  procedure REMOVE_USR_NAME
   (psUSERID in SYSTEM_USERS.USERID%type,
    psLANG_CODE in LANGUAGES.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_USR_NAME',
                             psUSERID || '~' || psLANG_CODE);
  --
    REMOVE_USR_TEXT(psUSERID, 'NAME', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_USR_NAME;
--
-- ----------------------------------------
-- SET_USR_TEXT
-- ----------------------------------------
--
  procedure SET_USR_TEXT
   (psUSERID in SYSTEM_USERS.USERID%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_USR_TEXT',
                             psUSERID || '~' || psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) ||
                             '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from SYSTEM_USERS where USERID = psUSERID;
  --
    TEXT.SET_TEXT(nTXT_ID, 'USR', psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_USR_TEXT;
--
-- ----------------------------------------
-- REMOVE_USR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_USR_TEXT
   (psUSERID in SYSTEM_USERS.USERID%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnTXI_SEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_USR_TEXT',
                             psUSERID || '~' || psTXTT_CODE || '~' || to_char(pnTXI_SEQ_NBR) ||
                               '~' || psLANG_CODE);
  --
    select TXT_ID into nTXT_ID from SYSTEM_USERS where USERID = psUSERID;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('USR', 7, 'en', 'Text type must be specified');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnTXI_SEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_USR_TEXT;
--
-- ----------------------------------------
-- SET_USER_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_USER_ATTRIBUTE_TYPE
   (psCODE in USER_ATTRIBUTE_TYPES.CODE%type,
    psDATA_TYPE in USER_ATTRIBUTE_TYPES.DATA_TYPE%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null,
    psDescription in varchar2 := null,
    pnDISPLAY_SEQ in USER_ATTRIBUTE_TYPES.DISPLAY_SEQ%type := -1e6,
    psACTIVE_FLAG in USER_ATTRIBUTE_TYPES.ACTIVE_FLAG%type := null)
  is
    sDATA_TYPE USER_ATTRIBUTE_TYPES.DATA_TYPE%type;
    nTXT_ID TEXT_HEADERS.ID%type;
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
    sACTIVE_FLAG LANGUAGES.ACTIVE_FLAG%type;
    sDummy varchar2(1);
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_USER_ATTRIBUTE_TYPE',
                             psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
                               psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check if user attribute type already exists.
  --
    begin
      select DATA_TYPE, TXT_ID
      into sDATA_TYPE, nTXT_ID
      from USER_ATTRIBUTE_TYPES
      where CODE = psCODE;
    exception
      when NO_DATA_FOUND
      then nTXT_ID := null;
        nSEQ_NBR := null;
    end;
  --
  -- Check if data type is to be changed and user attributes of this type already exist.
  --
    if psDATA_TYPE != sDATA_TYPE
    then
      begin
        select 'x' into sDummy from USER_ATTRIBUTES UAT where UATT_CODE = psCODE;
      --
        raise TOO_MANY_ROWS;
      exception
        when NO_DATA_FOUND
        then null;
      --
        when TOO_MANY_ROWS
        then MESSAGE.DISPLAY_MESSAGE('USR', 17, 'en', 'Cannot update data type of user attribute type already in use');
      end;
    end if;
  --
  -- Create or update description where required.
  --
    if psDescription is null
    then
      if nTXT_ID is null
      then MESSAGE.DISPLAY_MESSAGE('USR', 1, 'en', 'Description must be specified for new user attribute type');
      elsif psLANG_CODE is not null
      then MESSAGE.DISPLAY_MESSAGE('USR', 2, 'en', 'Description language cannot be specified without description text');
      elsif psDATA_TYPE is null
        and pnDISPLAY_SEQ = -1e6
        and psACTIVE_FLAG is null
      then MESSAGE.DISPLAY_MESSAGE('USR', 3, 'en', 'Nothing to be updated');
      end if;
    else
      begin
        select ACTIVE_FLAG into sACTIVE_FLAG from LANGUAGES where CODE = psLANG_CODE;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('USR', 4, 'en', 'Unknown description language');
      end;
    --
      if sACTIVE_FLAG = 'N'
      then MESSAGE.DISPLAY_MESSAGE('USR', 5, 'en', 'Inactive description language');
      end if;
    --
      TEXT.SET_TEXT(nTXT_ID, 'UATT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
    end if;
  --
    merge into USER_ATTRIBUTE_TYPES UATT
    using
     (select psCODE CODE from DUAL) INP
    on (UATT.CODE = INP.CODE)
    when matched then
      update
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG)
      where psDATA_TYPE is not null
        or nvl(pnDISPLAY_SEQ, 0) != -1e6
        or psACTIVE_FLAG is not null
    when not matched then
      insert
       (CODE, DATA_TYPE, DISPLAY_SEQ,
        ACTIVE_FLAG, TXT_ID)
      values
       (psCODE, psDATA_TYPE, case when pnDISPLAY_SEQ != -1e6 then pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'), nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_USER_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_USER_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_USER_ATTRIBUTE_TYPE
   (psCODE in USER_ATTRIBUTE_TYPES.CODE%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_USER_ATTRIBUTE_TYPE', psCODE);
  --
    delete from USER_ATTRIBUTE_TYPES where CODE = psCODE returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('USR', 6, 'en', 'User attribute type does not exist');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_USER_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_UATT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_UATT_DESCRIPTION
   (psCODE in USER_ATTRIBUTE_TYPES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psDescription in varchar2)
  is
    nSEQ_NBR TEXT_ITEMS.SEQ_NBR%type := 1;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_UATT_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE || '~' ||
                               to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_UATT_TEXT(psCODE, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_UATT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_UATT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_UATT_DESCRIPTION
   (psCODE in USER_ATTRIBUTE_TYPES.CODE%type,
    psLANG_CODE in LANGUAGES.CODE%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_UATT_DESCRIPTION',
                             psCODE || '~' || psLANG_CODE);
  --
    REMOVE_UATT_TEXT(psCODE, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_UATT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_UATT_TEXT
-- ----------------------------------------
--
  procedure SET_UATT_TEXT
   (psCODE in USER_ATTRIBUTE_TYPES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_UATT_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID into nTXT_ID from USER_ATTRIBUTE_TYPES where CODE = psCODE;
  --
    TEXT.SET_TEXT(nTXT_ID, 'UATT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_UATT_TEXT;
--
-- ----------------------------------------
-- REMOVE_UATT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_UATT_TEXT
   (psCODE in USER_ATTRIBUTE_TYPES.CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_UATT_TEXT',
                             psCODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID into nTXT_ID from USER_ATTRIBUTE_TYPES where CODE = psCODE;
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('USR', 7, 'en', 'Text type must be specified');
    end if;
  --
    TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_UATT_TEXT;
--
-- ----------------------------------------
-- SET_USER_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_USER_ATTRIBUTE
   (psUSERID in USER_ATTRIBUTES.USERID%type,
    psUATT_CODE in USER_ATTRIBUTES.UATT_CODE%type,
    psCHAR_VALUE in USER_ATTRIBUTES.CHAR_VALUE%type := null,
    pnNUM_VALUE in USER_ATTRIBUTES.NUM_VALUE%type := null,
    pdDATE_VALUE in USER_ATTRIBUTES.DATE_VALUE%type := null)
  is
    sDATA_TYPE USER_ATTRIBUTE_TYPES.DATA_TYPE%type;
    sACTIVE_FLAG USER_ATTRIBUTE_TYPES.ACTIVE_FLAG%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_USER_ATTRIBUTE',
                             psUSERID || '~' || psUATT_CODE || '~' ||
                             psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
                             to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    begin
      select DATA_TYPE, ACTIVE_FLAG
      into sDATA_TYPE, sACTIVE_FLAG
      from USER_ATTRIBUTE_TYPES
      where CODE = psUATT_CODE;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('USR', 19, 'en', 'Unknown user attribute type');
    end;
  --
    if sACTIVE_FLAG = 'N'
    then MESSAGE.DISPLAY_MESSAGE('USR', 20, 'en', 'Inactive user attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else MESSAGE.DISPLAY_MESSAGE('USR', 21, 'en', 'Attribute of the correct type must be specified');
    end case;
  --
    merge into USER_ATTRIBUTES UAT
    using
     (select psUSERID USERID, psUATT_CODE UATT_CODE from DUAL) INP
    on (UAT.USERID = INP.USERID and UAT.UATT_CODE = INP.UATT_CODE)
    when matched then
      update
      set CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE
    when not matched then
      insert (USERID, UATT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
      values (psUSERID, psUATT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_USER_ATTRIBUTE;
--
-- ----------------------------------------
-- REMOVE_USER_ATTRIBUTE
-- ----------------------------------------
--
  procedure REMOVE_USER_ATTRIBUTE
   (psUSERID in USER_ATTRIBUTES.USERID%type,
    psUATT_CODE in USER_ATTRIBUTES.UATT_CODE%type)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_USER_ATTRIBUTE',
                             psUSERID || '~' || psUATT_CODE);
  --
    delete from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE
    returning TXT_ID into nTXT_ID;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('USR', 18, 'en', 'User attribute does not exist');
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
  end REMOVE_USER_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_UAT_TEXT
-- ----------------------------------------
--
  procedure SET_UAT_TEXT
   (psUSERID in SYSTEM_USERS.USERID%type,
    psUATT_CODE in USER_ATTRIBUTES.UATT_CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psText in varchar2)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
    xUAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_UAT_TEXT',
                             psUSERID || '~' || psUATT_CODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, rowid
    into nTXT_ID, xUAT_ROWID
    from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE
    for update;
  --
    if nTXT_ID is null
    then
      TEXT.SET_TEXT(nTXT_ID, 'UAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update USER_ATTRIBUTES set TXT_ID = nTXT_ID where rowid = xUAT_ROWID;
    else
      TEXT.SET_TEXT(nTXT_ID, 'UAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    end if;

  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_UAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_UAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_UAT_TEXT
   (psUSERID in SYSTEM_USERS.USERID%type,
    psUATT_CODE in USER_ATTRIBUTES.UATT_CODE%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in LANGUAGES.CODE%type := null)
  is
    nTXT_ID TEXT_HEADERS.ID%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_UAT_TEXT',
                             psUSERID || '~' || psUATT_CODE || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    if psTXTT_CODE is null
    then MESSAGE.DISPLAY_MESSAGE('USR', 7, 'en', 'Text type must be specified');
    end if;
  --
    select TXT_ID
    into nTXT_ID
    from USER_ATTRIBUTES
    where USERID = psUSERID
    and UATT_CODE = psUATT_CODE;
  --
    if nTXT_ID is not null
    then TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_UAT_TEXT;
--
-- ----------------------------------------
-- SET_USER_LANG_PREFERENCE
-- ----------------------------------------
--
  procedure SET_USER_LANG_PREFERENCE
   (psUSERID in USER_LANGUAGE_PREFERENCES.USERID%type,
    psLANG_CODE in USER_LANGUAGE_PREFERENCES.LANG_CODE%type,
    pnPREF_SEQ in USER_LANGUAGE_PREFERENCES.PREF_SEQ%type)
  is
    sACTIVE_FLAG LANGUAGES.ACTIVE_FLAG%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.SET_USER_LANG_PREFERENCE',
                             psUSERID || '~' || psLANG_CODE || '~' || to_char(pnPREF_SEQ));
  --
    begin
      select ACTIVE_FLAG into sACTIVE_FLAG from LANGUAGES where CODE = psLANG_CODE;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('USR', 13, 'en', 'Unknown preference language');
    end;
  --
    if sACTIVE_FLAG = 'N'
    then MESSAGE.DISPLAY_MESSAGE('USR', 14, 'en', 'Inactive preference language');
    end if;
  --
    merge into USER_LANGUAGE_PREFERENCES ULP
    using
     (select psUSERID USERID, psLANG_CODE LANG_CODE from DUAL) INP
    on (ULP.USERID = INP.USERID and ULP.LANG_CODE = INP.LANG_CODE)
    when matched then
      update
      set PREF_SEQ = pnPREF_SEQ
      where PREF_SEQ != pnPREF_SEQ
    when not matched then
      insert (USERID, LANG_CODE, PREF_SEQ)
      values (psUSERID, psLANG_CODE, pnPREF_SEQ);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_USER_LANG_PREFERENCE;
--
-- ----------------------------------------
-- REMOVE_USER_LANG_PREFERENCE
-- ----------------------------------------
--
  procedure REMOVE_USER_LANG_PREFERENCE
   (psUSERID in USER_LANGUAGE_PREFERENCES.USERID%type,
    psLANG_CODE in USER_LANGUAGE_PREFERENCES.LANG_CODE%type := null,
    pnPREF_SEQ in USER_LANGUAGE_PREFERENCES.PREF_SEQ%type := null)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.REMOVE_USER_LANG_PREFERENCE',
                             psUSERID || '~' || psLANG_CODE || '~' || to_char(pnPREF_SEQ));
  --
    if psLANG_CODE is not null
    then
      if pnPREF_SEQ is not null
      then
        delete from USER_LANGUAGE_PREFERENCES
        where USERID = psUSERID
        and LANG_CODE = psLANG_CODE
        and PREF_SEQ = pnPREF_SEQ;
      else
        delete from USER_LANGUAGE_PREFERENCES
        where USERID = psUSERID
        and LANG_CODE = psLANG_CODE;
      end if;
    else
      if pnPREF_SEQ is not null
      then
        delete from USER_LANGUAGE_PREFERENCES
        where USERID = psUSERID
        and PREF_SEQ = pnPREF_SEQ;
      else MESSAGE.DISPLAY_MESSAGE('USR', 15, 'en', 'Language or preference sequence (or both) must be specified');
      end if;
    end if;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('USR', 16, 'en', 'Language preference does not exist');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_USER_LANG_PREFERENCE;
--
-- ----------------------------------------
-- USER_LOGIN
-- ----------------------------------------
--
  procedure USER_LOGIN
   (psUSERID in SYSTEM_USERS.USERID%type)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.USER_LOGIN', psUSERID);
  --
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end USER_LOGIN;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'SYSTEM_USER'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'en', 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'en', 'Module version mismatch');
  end if;
--
end SYSTEM_USER;
/

show errors
