create or replace package body P_AGE_PROFILE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_AGE_PROFILE
-- ----------------------------------------
--
  procedure INSERT_AGE_PROFILE
   (psCODE in P_BASE.tmsAGP_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnAGP_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsAGP_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_AGE_PROFILE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'AGP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into AGE_PROFILES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_AGE_PROFILE;
--
-- ----------------------------------------
-- UPDATE_AGE_PROFILE
-- ----------------------------------------
--
  procedure UPDATE_AGE_PROFILE
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in out P_BASE.tnAGP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnAGP_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsAGP_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGP_VERSION_NBR;
    xAGP_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_AGE_PROFILE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGP_ROWID
    from AGE_PROFILES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'AGP', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update AGE_PROFILES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xAGP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 1, 'Age profile has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_AGE_PROFILE;
--
-- ----------------------------------------
-- SET_AGE_PROFILE
-- ----------------------------------------
--
  procedure SET_AGE_PROFILE
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in out P_BASE.tnAGP_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnAGP_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsAGP_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_AGE_PROFILE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_AGE_PROFILE(psCODE, psLANG_CODE, psDescription,
                         case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                         nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_AGE_PROFILE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                         pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_AGE_PROFILE;
--
-- ----------------------------------------
-- DELETE_AGE_PROFILE
-- ----------------------------------------
--
  procedure DELETE_AGE_PROFILE
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in P_BASE.tnAGP_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGP_VERSION_NBR;
    xAGP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_AGE_PROFILE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGP_ROWID
    from AGE_PROFILES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from AGE_PROFILES where rowid = xAGP_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 1, 'Age profile has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_AGE_PROFILE;
--
-- ----------------------------------------
-- SET_AGP_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_AGP_DESCRIPTION
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in out P_BASE.tnAGP_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_AGP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_AGP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_AGP_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_AGP_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_AGP_DESCRIPTION
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in out P_BASE.tnAGP_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_AGP_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_AGP_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_AGP_DESCRIPTION;
--
-- ----------------------------------------
-- SET_AGP_TEXT
-- ----------------------------------------
--
  procedure SET_AGP_TEXT
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in out P_BASE.tnAGP_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGP_VERSION_NBR;
    xAGP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_AGP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGP_ROWID
    from AGE_PROFILES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'AGP', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update AGE_PROFILES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xAGP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 1, 'Age profile has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_AGP_TEXT;
--
-- ----------------------------------------
-- REMOVE_AGP_TEXT
-- ----------------------------------------
--
  procedure REMOVE_AGP_TEXT
   (psCODE in P_BASE.tmsAGP_CODE,
    pnVERSION_NBR in out P_BASE.tnAGP_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGP_VERSION_NBR;
    xAGP_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_AGP_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGP_ROWID
    from AGE_PROFILES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update AGE_PROFILES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xAGP_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 1, 'Age profile has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_AGP_TEXT;
--
-- ----------------------------------------
-- INSERT_AGE_RANGE
-- ----------------------------------------
--
  procedure INSERT_AGE_RANGE
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnAGE_TO in P_BASE.tmnAGR_AGE_TO,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_AGE_RANGE',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnAGE_TO) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'AGR', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into AGE_RANGES (AGP_CODE, AGE_FROM, AGE_TO, TXT_ID)
    values (psAGP_CODE, pnAGE_FROM, pnAGE_TO, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_AGE_RANGE;
--
-- ----------------------------------------
-- UPDATE_AGE_RANGE
-- ----------------------------------------
--
  procedure UPDATE_AGE_RANGE
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnVERSION_NBR in out P_BASE.tnAGR_VERSION_NBR,
    pnAGE_FROM_NEW in P_BASE.tnAGR_AGE_FROM := null,
    pnAGE_TO in P_BASE.tnAGR_AGE_TO := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null)
  is
    nAGE_TO P_BASE.tnAGR_AGE_TO;
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGR_VERSION_NBR;
    xAGR_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_AGE_RANGE',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnAGE_FROM_NEW) || '~' || to_char(pnAGE_TO) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select AGE_TO, TXT_ID, VERSION_NBR, rowid
    into nAGE_TO, nTXT_ID, nVERSION_NBR, xAGR_ROWID
    from AGE_RANGES
    where AGP_CODE = psAGP_CODE
    and AGE_FROM = pnAGE_FROM
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check for attempt to change an age range already in use.
    --
      if pnAGE_FROM_NEW != pnAGE_FROM or pnAGE_TO != nAGE_TO
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from STATISTICS
          where AGP_CODE = psAGP_CODE
          and AGE_FROM = pnAGE_FROM;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('AGP', 3, 'Cannot change age range already in use');
        end;
      --
      -- Check for overlapping age range for the same age profile.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from AGE_RANGES
          where AGP_CODE = psAGP_CODE
          and AGE_FROM <= nvl(pnAGE_TO, nAGE_TO)
          and AGE_TO >= nvl(pnAGE_FROM_NEW, pnAGE_FROM)
          and AGE_FROM != pnAGE_FROM;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('AGP', 4, 'Overlapping age ranges for this age profile');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'AGR', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update AGE_RANGES
      set AGE_FROM = nvl(pnAGE_FROM_NEW, AGE_FROM),
        AGE_TO = nvl(pnAGE_TO, AGE_TO),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xAGR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 2, 'Age range has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_AGE_RANGE;
--
-- ----------------------------------------
-- DELETE_AGE_RANGE
-- ----------------------------------------
--
  procedure DELETE_AGE_RANGE
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnVERSION_NBR in P_BASE.tnAGR_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGR_VERSION_NBR;
    xAGR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_AGE_RANGE',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGR_ROWID
    from AGE_RANGES
    where AGP_CODE = psAGP_CODE
    and AGE_FROM = pnAGE_FROM
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from AGE_RANGES where rowid = xAGR_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 2, 'Age range has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_AGE_RANGE;
--
-- ----------------------------------------
-- SET_AGR_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_AGR_DESCRIPTION
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnVERSION_NBR in out P_BASE.tnAGR_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_AGR_DESCRIPTION',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_AGR_TEXT(psAGP_CODE, pnAGE_FROM, pnVERSION_NBR,
                 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_AGR_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_AGR_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_AGR_DESCRIPTION
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnVERSION_NBR in out P_BASE.tnAGR_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_AGR_DESCRIPTION',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE);
  --
    REMOVE_AGR_TEXT(psAGP_CODE, pnAGE_FROM, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_AGR_DESCRIPTION;
--
-- ----------------------------------------
-- SET_AGR_TEXT
-- ----------------------------------------
--
  procedure SET_AGR_TEXT
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnVERSION_NBR in out P_BASE.tnAGR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGR_VERSION_NBR;
    xAGR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_AGR_TEXT',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGR_ROWID
    from AGE_RANGES
    where AGP_CODE = psAGP_CODE
    and AGE_FROM = pnAGE_FROM
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'AGR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update AGE_RANGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xAGR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 2, 'Age range has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_AGR_TEXT;
--
-- ----------------------------------------
-- REMOVE_AGR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_AGR_TEXT
   (psAGP_CODE in P_BASE.tmsAGP_CODE,
    pnAGE_FROM in P_BASE.tmnAGR_AGE_FROM,
    pnVERSION_NBR in out P_BASE.tnAGR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnAGR_VERSION_NBR;
    xAGR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_AGR_TEXT',
      psAGP_CODE || '~' || to_char(pnAGE_FROM) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xAGR_ROWID
    from AGE_RANGES
    where AGP_CODE = psAGP_CODE
    and AGE_FROM = pnAGE_FROM
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update AGE_RANGES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xAGR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('AGP', 2, 'Age range has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_AGR_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'AGP'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_AGE_PROFILE;
/

show errors
