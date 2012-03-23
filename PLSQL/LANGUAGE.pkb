create or replace package body LANGUAGE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_LANGUAGE
-- ----------------------------------------
--
  procedure INSERT_LANGUAGE
   (psCODE in tmsLANG_CODE,
    psLANG_CODE in tmsLANG_CODE,
    psDescription in tmsText,
    pnDISPLAY_SEQ in tnLANG_DISPLAY_SEQ := null,
    psACTIVE_FLAG in tmsACTIVE_FLAG := 'Y')
  is
    nTXT_ID tnTXT_ID;
    nSEQ_NBR tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_LANGUAGE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    TEXT.SET_TEXT(nTXT_ID, 'LANG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into LANGUAGES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LANGUAGE;
--
-- ----------------------------------------
-- UPDATE_LANGUAGE
-- ----------------------------------------
--
  procedure UPDATE_LANGUAGE
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in out tnLANG_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psDescription in tsText := null,
    pnDISPLAY_SEQ in tnLANG_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in tsLANG_ACTIVE_FLAG := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnLANG_VERSION_NBR;
    xLANG_ROWID rowid;
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_LANGUAGE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLANG_ROWID
    from LANGUAGES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psLANG_CODE is null and psDescription is null
      then
        if pnDISPLAY_SEQ = -1e6
          and psACTIVE_FLAG is null
        then MESSAGE.DISPLAY_MESSAGE('LANG', 2, 'Nothing to be updated');
        end if;
      else
        TEXT.SET_TEXT(nTXT_ID, 'LANG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update LANGUAGES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLANG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('LANG', 1, 'Language has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LANGUAGE;
--
-- ----------------------------------------
-- SET_LANGUAGE
-- ----------------------------------------
--
  procedure SET_LANGUAGE
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in out tnLANG_VERSION_NBR,
    psLANG_CODE in tsLANG_CODE := null,
    psDescription in tsText := null,
    pnDISPLAY_SEQ in tnLANG_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in tsLANG_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_LANGUAGE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LANGUAGE(psCODE, psLANG_CODE, psDescription,
                      case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                      nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LANGUAGE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                      pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LANGUAGE;
--
-- ----------------------------------------
-- DELETE_LANGUAGE
-- ----------------------------------------
--
  procedure DELETE_LANGUAGE
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in tnLANG_VERSION_NBR)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnLANG_VERSION_NBR;
    xLANG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_LANGUAGE', psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLANG_ROWID
    from LANGUAGES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from LANGUAGES where rowid = xLANG_ROWID;
    --
      TEXT.DELETE_TEXT(nTXT_ID);
    else
      MESSAGE.DISPLAY_MESSAGE('LANG', 1, 'Language has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LANGUAGE;
--
-- ----------------------------------------
-- SET_LANG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LANG_DESCRIPTION
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in out tnLANG_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psDescription in tmsText)
  is
    nSEQ_NBR tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_LANG_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LANG_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LANG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LANG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LANG_DESCRIPTION
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in out tnLANG_VERSION_NBR,
    psLANG_CODE in tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_LANG_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LANG_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LANG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LANG_TEXT
-- ----------------------------------------
--
  procedure SET_LANG_TEXT
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in out tnLANG_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in out tnTXI_SEQ_NBR,
    psLANG_CODE in tmsLANG_CODE,
    psText in tmsText)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnLANG_VERSION_NBR;
    xLANG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_LANG_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLANG_ROWID
    from LANGUAGES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.SET_TEXT(nTXT_ID, 'LANG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LANGUAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLANG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('LANG', 1, 'Language has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LANG_TEXT;
--
-- ----------------------------------------
-- REMOVE_LANG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LANG_TEXT
   (psCODE in tmsLANG_CODE,
    pnVERSION_NBR in out tnLANG_VERSION_NBR,
    psTXTT_CODE in tmsTXTT_CODE,
    pnSEQ_NBR in tnTXI_SEQ_NBR := null,
    psLANG_CODE in tsLANG_CODE := null)
  is
    nTXT_ID tnTXT_ID;
    nVERSION_NBR tnLANG_VERSION_NBR;
    xLANG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_LANG_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLANG_ROWID
    from LANGUAGES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LANGUAGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLANG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      MESSAGE.DISPLAY_MESSAGE('LANG', 1, 'Language has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LANG_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'LANGUAGE'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end LANGUAGE;
/

show errors
