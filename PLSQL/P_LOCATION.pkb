create or replace package body P_LOCATION is
--
-- ========================================
-- Local global variables
-- ========================================
--
  gsCOUNTRY_LOCT_CODE P_BASE.tsLOCT_CODE;  -- Location type of standard country code.
--
-- Parameters used in calculating hashed, check-digited location code.
--
  gnLOC_CODE_MULTIPLIER number;
  gnLOC_CODE_INCREMENT number;
  gnLOC_CODE_CHECK_MULTIPLIER number;
  gnLOC_CODE_CHECK_INCREMENT number;
  gnLOC_CODE_CHECK_MODULUS number;
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_LOCATION_TYPE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnLOCT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsLOCT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'LOCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into LOCATION_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LOCATION_TYPE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_TYPE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCT_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCT_ROWID
    from LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is null
      then
        if pnDISPLAY_SEQ = -1e6
          and psACTIVE_FLAG is null
        then P_MESSAGE.DISPLAY_MESSAGE('LOCT', 7, 'Nothing to be updated');
        end if;
      else
        P_TEXT.SET_TEXT(nTXT_ID, 'LOCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update LOCATION_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOCT', 1, 'Location type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LOCATION_TYPE;
--
-- ----------------------------------------
-- SET_LOCATION_TYPE
-- ----------------------------------------
--
  procedure SET_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_TYPE(psCODE, psLANG_CODE, psDescription,
                           case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                           nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_TYPE(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                           pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCATION_TYPE;
--
-- ----------------------------------------
-- DELETE_LOCATION_TYPE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_TYPE
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCT_ROWID
    from LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from TEXT_TYPES where rowid = xLOCT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOCT', 1, 'Location type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LOCATION_TYPE;
--
-- ----------------------------------------
-- SET_LOCT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCT_TEXT
-- ----------------------------------------
--
  procedure SET_LOCT_TEXT
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCT_ROWID
    from LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'LOCT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LOCATION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 1, 'Location type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCT_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCT_TEXT
   (psCODE in P_BASE.tmsLOCT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCT_ROWID
    from LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LOCATION_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 1, 'Location type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION
-- ----------------------------------------
--
  procedure INSERT_LOCATION
   (pnCODE out P_BASE.tnLOC_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText,
    psLOCT_CODE in P_BASE.tmsLOCT_CODE,
    psCOUNTRY_CODE in P_BASE.tsLOC_COUNTRY_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION',
      to_char(pnCODE) || '~' || psLOCT_CODE || '~' || psCOUNTRY_CODE || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
  -- Special processing for countries.
  --
    if psLOCT_CODE = 'COUNTRY'
    then
      if psCOUNTRY_CODE is null
      then
        P_MESSAGE.DISPLAY_MESSAGE('LOC', 8, 'Country code must be specified for new country');
      else
      --
      -- Check for existing country with same country code and overlapping effective date range.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from LOCATIONS
          where COUNTRY_CODE = psCOUNTRY_CODE
          and START_DATE <= nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
          and END_DATE >= nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('LOC', 9, 'Country with this code already exists');
        end;
      end if;
    end if;
  --
  -- Generate new location code.
  --
    select LOC_SEQ.nextval into pnCODE from DUAL;
  --
    pnCODE :=
      mod(pnCODE * gnLOC_CODE_MULTIPLIER + gnLOC_CODE_INCREMENT, 1e8) +
        (gnLOC_CODE_CHECK_INCREMENT -
          mod(pnCODE * gnLOC_CODE_CHECK_MULTIPLIER, gnLOC_CODE_CHECK_MODULUS)) * 1e8;
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    insert into LOCATIONS
     (CODE, LOCT_CODE, COUNTRY_CODE,
      START_DATE, END_DATE, TXT_ID)
    values
     (pnCODE, psLOCT_CODE, psCOUNTRY_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), nTXT_ID);
  --
  -- Create location attribute for country code if necessary.
  --
    if psLOCT_CODE = 'COUNTRY'
    then INSERT_LOCATION_ATTRIBUTE(pnCODE, gsCOUNTRY_LOCT_CODE, psCOUNTRY_CODE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LOCATION;
--
-- ----------------------------------------
-- UPDATE_LOCATION
-- ----------------------------------------
--
  procedure UPDATE_LOCATION
   (pnCODE in P_BASE.tmnLOC_CODE,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    psCOUNTRY_CODE in P_BASE.tsLOC_COUNTRY_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    sLOCT_CODE P_BASE.tsLOCT_CODE;
    sCOUNTRY_CODE P_BASE.tsLOCT_CODE;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR) || '~' || psCOUNTRY_CODE || '~' ||
      to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
      to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
      psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    select LOCT_CODE, COUNTRY_CODE, START_DATE, END_DATE, TXT_ID, VERSION_NBR, rowid
    into sLOCT_CODE, sCOUNTRY_CODE, dSTART_DATE, dEND_DATE, nTXT_ID, nVERSION_NBR, xLOC_ROWID
    from LOCATIONS
    where CODE = pnCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if pdSTART_DATE = P_BASE.gdFALSE_DATE
      then dSTART_DATE := P_BASE.gdMIN_DATE;
      else dSTART_DATE := nvl(pdSTART_DATE, dSTART_DATE);
      end if;
    --
      if pdEND_DATE = P_BASE.gdFALSE_DATE
      then dEND_DATE := P_BASE.gdMAX_DATE;
      else dEND_DATE := nvl(pdEND_DATE, dEND_DATE);
      end if;
    --
    -- Special processing for countries.
    --
      if sLOCT_CODE = 'COUNTRY'
      then
        if psCOUNTRY_CODE is not null
          or pdSTART_DATE is not null
          or pdEND_DATE is not null
        then
        --
        -- Check for existing country with same country code and overlapping effective date range.
        --
          declare
            sDummy varchar2(1);
          begin
            select 'x'
            into sDummy
            from LOCATIONS
            where COUNTRY_CODE = nvl(psCOUNTRY_CODE, sCOUNTRY_CODE)
            and START_DATE <= dEND_DATE
            and END_DATE >= dSTART_DATE
            and CODE != pnCODE;
          --
            raise TOO_MANY_ROWS;
          exception
            when NO_DATA_FOUND then null;
          --
            when TOO_MANY_ROWS
            then P_MESSAGE.DISPLAY_MESSAGE('LOC', 9, 'Country with this code already exists');
          end;
        end if;
      elsif psCOUNTRY_CODE is not null
      then
        P_MESSAGE.DISPLAY_MESSAGE('LOC', 10, 'Country code can only be specified for countries');
      end if;
    --
      if psLANG_CODE is null and psName is null
      then
        if psCOUNTRY_CODE is null
          and pdSTART_DATE = P_BASE.gdFALSE_DATE
          and pdEND_DATE = P_BASE.gdFALSE_DATE
        then P_MESSAGE.DISPLAY_MESSAGE('LOC', 7, 'Nothing to be updated');
        end if;
      else
        P_TEXT.SET_TEXT(nTXT_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
      end if;
    --
      update LOCATIONS
      set COUNTRY_CODE = nvl(psCOUNTRY_CODE, COUNTRY_CODE),
        START_DATE = dSTART_DATE,
        END_DATE = dEND_DATE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 2, 'Location has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LOCATION;
--
-- ----------------------------------------
-- SET_LOCATION
-- ----------------------------------------
--
  procedure SET_LOCATION
   (pnCODE in out P_BASE.tnLOC_CODE,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    psLOCT_CODE in P_BASE.tsLOCT_CODE := null,
    psCOUNTRY_CODE in P_BASE.tsLOC_COUNTRY_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR) || '~' || psLOCT_CODE || '~' ||
        psCOUNTRY_CODE || '~' || to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION(pnCODE, psLANG_CODE, psName, psLOCT_CODE, psCOUNTRY_CODE,
                      case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
                      case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end);
    --
      pnVERSION_NBR := 1;
    elsif psLOCT_CODE is not null
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 11, 'Location type cannot be updated');
    else
      UPDATE_LOCATION(pnCODE, pnVERSION_NBR, psLANG_CODE, psName, psCOUNTRY_CODE,
                      pdSTART_DATE, pdEND_DATE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCATION;
--
-- ----------------------------------------
-- DELETE_LOCATION
-- ----------------------------------------
--
  procedure DELETE_LOCATION
   (pnCODE in P_BASE.tmnLOC_CODE,
    pnVERSION_NBR in P_BASE.tnLOC_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOC_ROWID
    from LOCATIONS
    where CODE = pnCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from LOCATIONS where rowid = xLOC_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 2, 'Location has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LOCATION;
--
-- ----------------------------------------
-- SET_LOC_NAME
-- ----------------------------------------
--
  procedure SET_LOC_NAME
   (pnCODE in P_BASE.tmnLOC_CODE,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psName in P_BASE.tsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_NAME',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    SET_LOC_TEXT(pnCODE, pnVERSION_NBR, 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOC_NAME;
--
-- ----------------------------------------
-- REMOVE_LOC_NAME
-- ----------------------------------------
--
  procedure REMOVE_LOC_NAME
   (pnCODE in P_BASE.tmnLOC_CODE,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOC_NAME',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOC_TEXT(pnCODE, pnVERSION_NBR, 'NAME', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOC_NAME;
--
-- ----------------------------------------
-- SET_LOC_TEXT
-- ----------------------------------------
--
  procedure SET_LOC_TEXT
   (pnCODE in P_BASE.tmnLOC_CODE,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_TEXT',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOC_ROWID
    from LOCATIONS
    where CODE = pnCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'LOC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LOCATIONS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 2, 'Location has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOC_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOC_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOC_TEXT
   (pnCODE in P_BASE.tmnLOC_CODE,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOC_TEXT',
      to_char(pnCODE) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOC_ROWID
    from LOCATIONS
    where CODE = pnCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LOCATIONS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOC_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 2, 'Location has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOC_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    psDATA_TYPE in P_BASE.tmsLOCAT_DATA_TYPE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnLOCAT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsLOCAT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'LOCAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into LOCATION_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsLOCAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCAT_ACTIVE_FLAG := null)
  is
    sDATA_TYPE P_BASE.tsLOCAT_DATA_TYPE;
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, TXT_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nTXT_ID, nVERSION_NBR, xLOCAT_ROWID
    from LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check if data type is to be changed and location attributes of this type already exist.
    --
      if psDATA_TYPE != sDATA_TYPE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x' into sDummy from LOCATION_ATTRIBUTES where LOCAT_CODE = psCODE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('LOC', 12, 'Cannot update data type of location attribute type already in use');
        end;
      end if;
    --
      if psDescription is null
      then
        if psDATA_TYPE is null
          and pnDISPLAY_SEQ = -1e6
          and psACTIVE_FLAG is null
        then P_MESSAGE.DISPLAY_MESSAGE('LOC', 7, 'Nothing to be updated');
        end if;
      else
        P_TEXT.SET_TEXT(nTXT_ID, 'LOCAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update LOCATION_ATTRIBUTE_TYPES
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 3, 'Location attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsLOCAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCAT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE_TYPE
       (psCODE, psDATA_TYPE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psDATA_TYPE, psLANG_CODE, psDescription,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_LOCATION_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCAT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCAT_ROWID
    from LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from LOCATION_ATTRIBUTE_TYPES where rowid = xLOCAT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 3, 'Location attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LOCATION_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_LOCAT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCAT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCAT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCAT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCAT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCAT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCAT_TEXT
-- ----------------------------------------
--
  procedure SET_LOCAT_TEXT
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCAT_ROWID
    from LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'LOCAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LOCATION_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 3, 'Location attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCAT_TEXT
   (psCODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCAT_ROWID
    from LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LOCATION_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('TXTT', 3, 'Location attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCAT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_ATTRIBUTE
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsLOCAT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsLOCAT_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_ATTRIBUTE',
      to_char(pnLOC_CODE) || '~' || psLOCAT_CODE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from LOCATION_ATTRIBUTE_TYPES
    where CODE = psLOCAT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 13, 'Inactive location attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE('LOC', 14, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into LOCATION_ATTRIBUTES (LOC_CODE, LOCAT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (pnLOC_CODE, psLOCAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_ATTRIBUTE
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_ATTRIBUTE',
      to_char(pnLOC_CODE) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xLOCA_ROWID
    from LOCATION_ATTRIBUTES
    where LOC_CODE = pnLOC_CODE
    and LOCAT_CODE = psLOCAT_CODE;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update LOCATION_ATTRIBUTES
      set CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 4, 'Location attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_LOCATION_ATTRIBUTE
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_ATTRIBUTE',
      to_char(pnLOC_CODE) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE
       (pnLOC_CODE, psLOCAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE
       (pnLOC_CODE, psLOCAT_CODE, pnVERSION_NBR, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_ATTRIBUTE
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCA_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_ATTRIBUTE',
      to_char(pnLOC_CODE) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCA_ROWID
    from LOCATION_ATTRIBUTES
    where LOC_CODE = pnLOC_CODE
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from LOCATION_ATTRIBUTES where rowid = xLOCA_ROWID;
    --
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 4, 'Location attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_LOCA_TEXT
-- ----------------------------------------
--
  procedure SET_LOCA_TEXT
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCA_TEXT',
      to_char(pnLOC_CODE) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCA_ROWID
    from LOCATION_ATTRIBUTES
    where LOC_CODE = pnLOC_CODE
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'LOCA', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LOCATION_ATTRIBUTES
      set TXT_ID = nTXT_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 4, 'Location attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCA_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCA_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCA_TEXT
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCA_TEXT',
      to_char(pnLOC_CODE) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCA_ROWID
    from LOCATION_ATTRIBUTES
    where LOC_CODE = pnLOC_CODE
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LOCATION_ATTRIBUTES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 4, 'Location attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCA_TEXT;
--
-- ----------------------------------------
-- INSERT_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure INSERT_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnLOCRT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsLOCRT_ACTIVE_FLAG := 'Y')
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'LOCRT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into LOCATION_RELATIONSHIP_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, TXT_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- UPDATE_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure UPDATE_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCRT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCRT_ACTIVE_FLAG := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCRT_ROWID
    from LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is null
      then
        if pnDISPLAY_SEQ = -1e6
          and psACTIVE_FLAG is null
        then P_MESSAGE.DISPLAY_MESSAGE('LOC', 7, 'Nothing to be updated');
        end if;
      else
        P_TEXT.SET_TEXT(nTXT_ID, 'LOCRT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update LOCATION_RELATIONSHIP_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCRT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 5, 'Location relationship type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- SET_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure SET_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCRT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCRT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE_TYPE
       (psCODE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psLANG_CODE, psDescription, pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- DELETE_LOC_RELATIONSHIP_TYPE
-- ----------------------------------------
--
  procedure DELETE_LOC_RELATIONSHIP_TYPE
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCRT_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCRT_ROWID
    from LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from LOCATION_RELATIONSHIP_TYPES where rowid = xLOCRT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 5, 'Location relationship type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LOC_RELATIONSHIP_TYPE;
--
-- ----------------------------------------
-- SET_LOCRT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCRT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCRT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCRT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCRT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCRT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCRT_DESCRIPTION
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCRT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCRT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCRT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCRT_TEXT
-- ----------------------------------------
--
  procedure SET_LOCRT_TEXT
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCRT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCRT_ROWID
    from LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'LOCRT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LOCATION_RELATIONSHIP_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCRT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 5, 'Location relationship type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCRT_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCRT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCRT_TEXT
   (psCODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCRT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCRT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCRT_ROWID
    from LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LOCATION_RELATIONSHIP_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCRT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('TXTT', 5, 'Location relationship type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCRT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure INSERT_LOCATION_RELATIONSHIP
   (pnLOC_CODE_PARENT in P_BASE.tmnLOC_CODE,
    pnLOC_CODE_CHILD in P_BASE.tmnLOC_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    sACTIVE_FLAG P_BASE.tsLOCAT_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_RELATIONSHIP',
      to_char(pnLOC_CODE_PARENT) || '~' || to_char(pnLOC_CODE_CHILD) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select ACTIVE_FLAG into sACTIVE_FLAG from LOCATION_RELATIONSHIP_TYPES where CODE = psLOCRT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 15, 'Inactive location relationship type');
    end if;
  --
  -- Check for an existing relationship of the same type between these locations with overlapping
  --  effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from LOCATION_RELATIONSHIPS
      where LOC_CODE_PARENT = pnLOC_CODE_PARENT
      and LOC_CODE_CHILD = pnLOC_CODE_CHILD
      and LOCRT_CODE = psLOCRT_CODE
      and START_DATE <= pdEND_DATE
      and END_DATE >= pdSTART_DATE;
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE('LOC', 16, 'Overlapping location relationship already exists');
    end;
  --
    insert into LOCATION_RELATIONSHIPS
     (LOC_CODE_PARENT, LOC_CODE_CHILD, LOCRT_CODE, START_DATE,
      END_DATE)
    values
     (pnLOC_CODE_PARENT, pnLOC_CODE_CHILD, psLOCRT_CODE, nvl(pdSTART_DATE, P_BASE.gdMIN_DATE),
      nvl(pdEND_DATE, P_BASE.gdMAX_DATE));
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- UPDATE_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_RELATIONSHIP
   (pnLOC_CODE_PARENT in P_BASE.tmnLOC_CODE,
    pnLOC_CODE_CHILD in P_BASE.tmnLOC_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    pdSTART_DATE_NEW in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_RELATIONSHIP',
      to_char(pnLOC_CODE_PARENT) || '~' || to_char(pnLOC_CODE_CHILD) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || to_char(pdSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') ||
        '~' || to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select VERSION_NBR, rowid
    into nVERSION_NBR, xLOCR_ROWID
    from LOCATION_RELATIONSHIPS
    where LOC_CODE_PARENT = pnLOC_CODE_PARENT
    and LOC_CODE_CHILD = pnLOC_CODE_CHILD
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check for relationship of the same type between these locations with overlapping effective
    --  date range.
    --
      declare
        sDummy varchar2(1);
      begin
        select 'x'
        into sDummy
        from LOCATION_RELATIONSHIPS
        where LOC_CODE_PARENT = pnLOC_CODE_PARENT
        and LOC_CODE_CHILD = pnLOC_CODE_CHILD
        and LOCRT_CODE = psLOCRT_CODE
        and START_DATE <= pdEND_DATE
        and END_DATE >= pdSTART_DATE
        and START_DATE != pdSTART_DATE;
      --
        raise TOO_MANY_ROWS;
      exception
        when NO_DATA_FOUND then null;
      --
        when TOO_MANY_ROWS
        then P_MESSAGE.DISPLAY_MESSAGE('LOC', 16, 'Overlapping location relationship already exists');
      end;
    --
      update LOCATION_RELATIONSHIPS
      set START_DATE =
          case
            when pdSTART_DATE = P_BASE.gdFALSE_DATE then START_DATE
            else nvl(pdSTART_DATE, P_BASE.gdMIN_DATE)
          end,
        END_DATE =
          case
            when pdEND_DATE = P_BASE.gdFALSE_DATE then END_DATE
            else nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
          end,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- DELETE_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure DELETE_LOCATION_RELATIONSHIP
   (pnLOC_CODE_PARENT in P_BASE.tmnLOC_CODE,
    pnLOC_CODE_CHILD in P_BASE.tmnLOC_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnLOCR_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_RELATIONSHIP',
      to_char(pnLOC_CODE_PARENT) || '~' || to_char(pnLOC_CODE_CHILD) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCR_ROWID
    from LOCATION_RELATIONSHIPS
    where LOC_CODE_PARENT = pnLOC_CODE_PARENT
    and LOC_CODE_CHILD = pnLOC_CODE_CHILD
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from LOCATION_RELATIONSHIPS where rowid = xLOCR_ROWID;
    --
      if nTXT_ID is not null
      then P_TEXT.DELETE_TEXT(nTXT_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- SET_LOCR_TEXT
-- ----------------------------------------
--
  procedure SET_LOCR_TEXT
   (pnLOC_CODE_PARENT in P_BASE.tmnLOC_CODE,
    pnLOC_CODE_CHILD in P_BASE.tmnLOC_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCR_TEXT',
      to_char(pnLOC_CODE_PARENT) || '~' || to_char(pnLOC_CODE_CHILD) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCR_ROWID
    from LOCATION_RELATIONSHIPS
    where LOC_CODE_PARENT = pnLOC_CODE_PARENT
    and LOC_CODE_CHILD = pnLOC_CODE_CHILD
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'LOCR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update LOCATION_RELATIONSHIPS
      set TXT_ID = nTXT_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_LOCR_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCR_TEXT
   (pnLOC_CODE_PARENT in P_BASE.tmnLOC_CODE,
    pnLOC_CODE_CHILD in P_BASE.tmnLOC_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCR_TEXT',
      to_char(pnLOC_CODE_PARENT) || '~' || to_char(pnLOC_CODE_CHILD) || '~' || psLOCRT_CODE ||
        '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) ||
        '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xLOCR_ROWID
    from LOCATION_RELATIONSHIPS
    where LOC_CODE_PARENT = pnLOC_CODE_PARENT
    and LOC_CODE_CHILD = pnLOC_CODE_CHILD
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update LOCATION_RELATIONSHIPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_LOCR_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'LOC'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  select CHAR_VALUE
  into gsCOUNTRY_LOCT_CODE
  from SYSTEM_PARAMETERS
  where CODE = 'COUNTRY LOCAT CODE';
--
  select NUM_VALUE
  into gnLOC_CODE_MULTIPLIER
  from SYSTEM_PARAMETERS
  where CODE = 'LOCATION CODE MULTIPLIER';
--
  select NUM_VALUE
  into gnLOC_CODE_INCREMENT
  from SYSTEM_PARAMETERS
  where CODE = 'LOCATION CODE INCREMENT';
--
  select NUM_VALUE
  into gnLOC_CODE_CHECK_MULTIPLIER
  from SYSTEM_PARAMETERS
  where CODE = 'LOCATION CODE CHECK MULTIPLIER';
--
  select NUM_VALUE
  into gnLOC_CODE_CHECK_INCREMENT
  from SYSTEM_PARAMETERS
  where CODE = 'LOCATION CODE CHECK INCREMENT';
--
  select NUM_VALUE
  into gnLOC_CODE_CHECK_MODULUS
  from SYSTEM_PARAMETERS
  where CODE = 'LOCATION CODE CHECK MODULUS';
--
end P_LOCATION;
/

show errors
