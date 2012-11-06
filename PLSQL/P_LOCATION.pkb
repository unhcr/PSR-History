create or replace package body P_LOCATION is
--
-- ========================================
-- Local global variables
-- ========================================
--
  gsCOUNTRY_LOCAT_CODE P_BASE.tsLOCT_CODE;  -- Location attribute type of standard country code.
--
-- Parameters used in calculating hashed, check-digited location code.
--
  gnLOC_ID_MULTIPLIER number;
  gnLOC_ID_INCREMENT number;
  gnLOC_ID_CHECK_MULTIPLIER number;
  gnLOC_ID_CHECK_INCREMENT number;
  gnLOC_ID_CHECK_MODULUS number;
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
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_TYPES
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 1, 'Location type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_TYPES where rowid = xLOCT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 1, 'Location type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCT_VERSION_NBR;
    xLOCT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCT_ROWID
    from T_LOCATION_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION
-- ----------------------------------------
--
  procedure INSERT_LOCATION
   (pnID out P_BASE.tnLOC_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psName in P_BASE.tmsText,
    psLOCT_CODE in P_BASE.tmsLOCT_CODE,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION',
      '~' || psLOCT_CODE || '~' || psCountryCode || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
  -- Special processing for countries.
  --
    if psLOCT_CODE = 'COUNTRY'
    then
      if psCountryCode is null
      then
        P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Country code must be specified for new country');
      else
      --
      -- Check for existing country with same country code and overlapping effective date range.
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATION_ATTRIBUTES LOCA
          join T_LOCATIONS LOC
            on LOC.ID = LOCA.LOC_ID
          where LOCA.CHAR_VALUE = psCountryCode
          and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
          and LOC.START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
          and LOC.END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Country with this code already exists');
        end;
      end if;
    end if;
  --
  -- Generate new location code.
  --
    select LOC_SEQ.nextval into pnID from DUAL;
  --
    pnID :=
      mod(pnID * gnLOC_ID_MULTIPLIER + gnLOC_ID_INCREMENT, 1e8) +
        (gnLOC_ID_CHECK_INCREMENT -
          mod(pnID * gnLOC_ID_CHECK_MULTIPLIER, gnLOC_ID_CHECK_MODULUS)) * 1e8;
  --
    PLS_UTILITY.TRACE_CONTEXT
     (to_char(pnID) || '~' || psLOCT_CODE || '~' || psCountryCode || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    insert into T_LOCATIONS
     (ID, LOCT_CODE,
      START_DATE, END_DATE, ITM_ID)
    values
     (pnID, psLOCT_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), nITM_ID);
  --
  -- Create location attribute for country code if necessary.
  --
    if psLOCT_CODE = 'COUNTRY'
    then INSERT_LOCATION_ATTRIBUTE(pnID, gsCOUNTRY_LOCAT_CODE, psCountryCode);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION;
--
-- ----------------------------------------
-- UPDATE_LOCATION
-- ----------------------------------------
--
  procedure UPDATE_LOCATION
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    pnLOCTV_ID in P_BASE.tnLOCTV_ID := -1,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    sLOCT_CODE P_BASE.tsLOCT_CODE;
    nLOCTV_ID P_BASE.tnLOCTV_ID;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    sCOUNTRY_CODE P_BASE.tsCountryCode;
    nLOCA_VERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnLOCTV_ID) || '~' || psCountryCode || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    select LOCT_CODE, LOCTV_ID, START_DATE, END_DATE, ITM_ID, VERSION_NBR, rowid
    into sLOCT_CODE, nLOCTV_ID, dSTART_DATE, dEND_DATE, nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Determine new values for dates.
    --
      if pdSTART_DATE = P_BASE.gdFALSE_DATE
      then dSTART_DATE_NEW := dSTART_DATE;
      else dSTART_DATE_NEW := nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
      end if;
    --
      if pdEND_DATE = P_BASE.gdFALSE_DATE
      then dEND_DATE_NEW := dEND_DATE;
      else dEND_DATE_NEW := nvl(pdEND_DATE, P_BASE.gdMAX_DATE);
      end if;
    --
    -- Special processing for countries.
    --
      if sLOCT_CODE = 'COUNTRY'
      then
      --
      -- Check if country code or effective date range might be being changed.
      --
        if psCountryCode is not null
          or dSTART_DATE_NEW != dSTART_DATE
          or dEND_DATE_NEW != dEND_DATE
        then
        --
        -- Get existing country code details.
        --
          select CHAR_VALUE, VERSION_NBR
          into sCOUNTRY_CODE, nLOCA_VERSION_NBR
          from T_LOCATION_ATTRIBUTES
          where LOC_ID = pnID
          and LOCAT_CODE = gsCOUNTRY_LOCAT_CODE;
        --
        -- Check if country code or effective date range are being changed.
        --
          if psCountryCode != sCOUNTRY_CODE
            or dSTART_DATE_NEW != dSTART_DATE
            or dEND_DATE_NEW != dEND_DATE
          then
          --
          -- Check for existing country with same country code and overlapping effective date range.
          --
            declare
              sDummy varchar2(1);
            begin
              select 'x'
              into sDummy
              from T_LOCATION_ATTRIBUTES LOCA
              join T_LOCATIONS LOC
                on LOC.ID = LOCA.LOC_ID
              where LOCA.CHAR_VALUE = nvl(psCountryCode, sCOUNTRY_CODE)
              and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
              and START_DATE < dEND_DATE_NEW
              and END_DATE > dSTART_DATE_NEW
              and ID != pnID;
            --
              raise TOO_MANY_ROWS;
            exception
              when NO_DATA_FOUND then null;
            --
              when TOO_MANY_ROWS
              then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Country with this code already exists');
            end;
          end if;
        end if;
      --
        if psCountryCode != sCOUNTRY_CODE
        then UPDATE_LOCATION_ATTRIBUTE(pnID, gsCOUNTRY_LOCAT_CODE, nLOCA_VERSION_NBR,
                                       psCountryCode);
        end if;
      elsif psCountryCode is not null
      then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Country code can only be specified for countries');
      end if;
    --
    --
    --
      if pnLOCTV_ID != -1
        and pnLOCTV_ID != nLOCTV_ID
      then
      --
      -- Check that location type association is valid
      --
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATION_TYPE_VARIANTS LOCTV
          join T_LOCATION_RELATIONSHIPS LOCR
            on LOCR.LOC_ID_FROM = LOCTV.LOC_ID
            and LOCR.LOC_ID_TO = pnID
            and LOCR.LOCRT_CODE = LOCTV.LOCRT_CODE
          where LOCTV.ID = pnLOCTV_ID
          and LOCTV.LOCT_CODE = sLOCT_CODE;
        exception
          when NO_DATA_FOUND
          then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Invalid location type variant for this location');
        end;
      end if;
    --
      if psName is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOC', 'NAME', nSEQ_NBR, psLANG_CODE, psName);
      end if;
    --
      update T_LOCATIONS
      set LOCTV_ID = case when pnLOCTV_ID = -1 then LOCTV_ID else pnLOCTV_ID end,
        START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION;
--
-- ----------------------------------------
-- SET_LOCATION
-- ----------------------------------------
--
  procedure SET_LOCATION
   (pnID in out P_BASE.tnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psName in P_BASE.tsText := null,
    psLOCT_CODE in P_BASE.tsLOCT_CODE := null,
    pnLOCTV_ID in P_BASE.tnLOCTV_ID := -1,
    psCountryCode in P_BASE.tsCountryCode := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLOCT_CODE || '~' ||
        to_char(pnLOCTV_ID) || '~' || psCountryCode || '~' ||
        to_date(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_date(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psName)) || ':' || psName);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION(pnID, psLANG_CODE, psName, psLOCT_CODE, psCountryCode,
                      case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
                      case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION(pnID, pnVERSION_NBR, psLANG_CODE, psName, pnLOCTV_ID, psCountryCode,
                      pdSTART_DATE, pdEND_DATE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION;
--
-- ----------------------------------------
-- DELETE_LOCATION
-- ----------------------------------------
--
  procedure DELETE_LOCATION
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in P_BASE.tnLOC_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATIONS where rowid = xLOC_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 2, 'Location has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION;
--
-- ----------------------------------------
-- SET_LOC_NAME
-- ----------------------------------------
--
  procedure SET_LOC_NAME
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psName in P_BASE.tsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_NAME',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psName)) || ':' || psName);
  --
    SET_LOC_TEXT(pnID, pnVERSION_NBR, 'NAME', nSEQ_NBR, psLANG_CODE, psName);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOC_NAME;
--
-- ----------------------------------------
-- REMOVE_LOC_NAME
-- ----------------------------------------
--
  procedure REMOVE_LOC_NAME
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOC_NAME',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOC_TEXT(pnID, pnVERSION_NBR, 'NAME', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOC_NAME;
--
-- ----------------------------------------
-- SET_LOC_TEXT
-- ----------------------------------------
--
  procedure SET_LOC_TEXT
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOC', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATIONS
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOC_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOC_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOC_TEXT
   (pnID in P_BASE.tmnLOC_ID,
    pnVERSION_NBR in out P_BASE.tnLOC_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
    xLOC_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOC_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOC_ROWID
    from T_LOCATIONS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATIONS
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, ITM_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
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
          select 'x' into sDummy from T_LOCATION_ATTRIBUTES where LOCAT_CODE = psCODE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('LOC', 10, 'Cannot update data type of location attribute type already in use');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_ATTRIBUTE_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_ATTRIBUTE_TYPES where rowid = xLOCAT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 3, 'Location attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_ATTRIBUTE_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCAT_VERSION_NBR;
    xLOCAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCAT_ROWID
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_ATTRIBUTE_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCAT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
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
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from T_LOCATION_ATTRIBUTE_TYPES
    where CODE = psLOCAT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 11, 'Inactive location attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE('LOC', 12, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into T_LOCATION_ATTRIBUTES (LOC_ID, LOCAT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (pnLOC_ID, psLOCAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
    sCHAR_VALUE P_BASE.tsLOCA_CHAR_VALUE;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select CHAR_VALUE, VERSION_NBR, rowid
    into sCHAR_VALUE, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Special processing for country code.
    --
      if psLOCAT_CODE = gsCOUNTRY_LOCAT_CODE
        and psCHAR_VALUE != sCHAR_VALUE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATIONS LOC1
          join T_LOCATION_ATTRIBUTES LOCA
            on LOCA.LOC_ID != LOC1.ID
            and LOCA.CHAR_VALUE = psCHAR_VALUE
            and LOCA.LOCAT_CODE = gsCOUNTRY_LOCAT_CODE
          join T_LOCATIONS LOC2
            on LOC2.ID = LOCA.LOC_ID
            and LOC2.START_DATE < LOC1.END_DATE
            and LOC2.END_DATE > LOC1.START_DATE
          where LOC1.ID = pnLOC_ID;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Country with this code already exists');
        end;
      end if;
    --
      update T_LOCATION_ATTRIBUTES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsLOCA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnLOCA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdLOCA_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_ATTRIBUTE
       (pnLOC_ID, psLOCAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_ATTRIBUTE
       (pnLOC_ID, psLOCAT_CODE, pnVERSION_NBR, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_LOCATION_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_LOCATION_ATTRIBUTE
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in P_BASE.tnLOCA_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_ATTRIBUTE',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    if psLOCAT_CODE = gsCOUNTRY_LOCAT_CODE
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Cannot delete the primary country code');
    end if;
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_ATTRIBUTES where rowid = xLOCA_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 4, 'Location attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_LOCA_TEXT
-- ----------------------------------------
--
  procedure SET_LOCA_TEXT
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCA_TEXT',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCA', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_ATTRIBUTES
      set ITM_ID = nITM_ID,
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCA_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCA_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCA_TEXT
   (pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCAT_CODE in P_BASE.tmsLOCAT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCA_VERSION_NBR;
    xLOCA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCA_TEXT',
      to_char(pnLOC_ID) || '~' || psLOCAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCA_ROWID
    from T_LOCATION_ATTRIBUTES
    where LOC_ID = pnLOC_ID
    and LOCAT_CODE = psLOCAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_ATTRIBUTES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCRT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_RELATIONSHIP_TYPES (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCRT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_RELATIONSHIP_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOC_RELATIONSHIP_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_RELATIONSHIP_TYPES where rowid = xLOCRT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 5, 'Location relationship type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCRT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCRT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_RELATIONSHIP_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
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
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCRT_VERSION_NBR;
    xLOCRT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCRT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCRT_ROWID
    from T_LOCATION_RELATIONSHIP_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_RELATIONSHIP_TYPES
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCRT_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure INSERT_LOCATION_RELATIONSHIP
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    sACTIVE_FLAG P_BASE.tsLOCRT_ACTIVE_FLAG;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_RELATIONSHIP',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select ACTIVE_FLAG into sACTIVE_FLAG from T_LOCATION_RELATIONSHIP_TYPES where CODE = psLOCRT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 13, 'Inactive location relationship type');
    end if;
  --
  -- Determine effective date range of the combined related locations.
  --
    select max(START_DATE), min(END_DATE)
    into dSTART_DATE, dEND_DATE
    from LOCATIONS
    where ID in (pnLOC_ID_FROM, pnLOC_ID_TO);
  --
  -- Check that effective date parameters (if specified) fall within the effective date range of the
  --  related locations, or default them if not specified.
  --
    if pdSTART_DATE < dSTART_DATE or pdEND_DATE > dEND_DATE
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Location relationship effective date range outside effective date range of related locations');
    else
      dSTART_DATE := nvl(pdSTART_DATE, dSTART_DATE);
      dEND_DATE := nvl(pdEND_DATE, dEND_DATE);
    end if;
    PLS_UTILITY.TRACE_POINT
     ('Dates', to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(dSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(dEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
  -- Check for an existing relationship between these locations of the same type and with an
  --  overlapping effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from T_LOCATION_RELATIONSHIPS
      where LOC_ID_FROM = pnLOC_ID_FROM
      and LOC_ID_TO = pnLOC_ID_TO
      and LOCRT_CODE = psLOCRT_CODE
      and START_DATE <= dEND_DATE
      and END_DATE >= dSTART_DATE;
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE('LOC', 14, 'Overlapping location relationship already exists');
    end;
  --
    insert into T_LOCATION_RELATIONSHIPS
     (LOC_ID_FROM, LOC_ID_TO, LOCRT_CODE, START_DATE, END_DATE)
    values
     (pnLOC_ID_FROM, pnLOC_ID_TO, psLOCRT_CODE, dSTART_DATE, dEND_DATE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- UPDATE_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_RELATIONSHIP
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    pdSTART_DATE_NEW in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    dEND_DATE P_BASE.tdDate;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_RELATIONSHIP',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || to_char(pdSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') ||
        '~' || to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select END_DATE, VERSION_NBR, rowid
    into dEND_DATE, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Determine new values for dates.
    --
      if pdSTART_DATE_NEW = P_BASE.gdFALSE_DATE
      then dSTART_DATE_NEW := pdSTART_DATE;
      else dSTART_DATE_NEW := nvl(pdSTART_DATE_NEW, P_BASE.gdMIN_DATE);
      end if;
    --
      if pdEND_DATE = P_BASE.gdFALSE_DATE
      then dEND_DATE_NEW := dEND_DATE;
      else dEND_DATE_NEW := nvl(pdEND_DATE, P_BASE.gdMAX_DATE);
      end if;
    --
    -- Check for relationship of the same type between these locations with overlapping effective
    --  date range.
    --
      declare
        sDummy varchar2(1);
      begin
        select 'x'
        into sDummy
        from T_LOCATION_RELATIONSHIPS
        where LOC_ID_FROM = pnLOC_ID_FROM
        and LOC_ID_TO = pnLOC_ID_TO
        and LOCRT_CODE = psLOCRT_CODE
        and START_DATE <= dEND_DATE_NEW
        and END_DATE >= dSTART_DATE_NEW
        and START_DATE != pdSTART_DATE;
      --
        raise TOO_MANY_ROWS;
      exception
        when NO_DATA_FOUND then null;
      --
        when TOO_MANY_ROWS
        then P_MESSAGE.DISPLAY_MESSAGE('LOC', 14, 'Overlapping location relationship already exists');
      end;
    --
      update T_LOCATION_RELATIONSHIPS
      set START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- DELETE_LOCATION_RELATIONSHIP
-- ----------------------------------------
--
  procedure DELETE_LOCATION_RELATIONSHIP
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnLOCR_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_RELATIONSHIP',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_RELATIONSHIPS where rowid = xLOCR_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_RELATIONSHIP;
--
-- ----------------------------------------
-- SET_LOCR_TEXT
-- ----------------------------------------
--
  procedure SET_LOCR_TEXT
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCR_TEXT',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' ||
        psLOCRT_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_RELATIONSHIPS
      set ITM_ID = nITM_ID,
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCR_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCR_TEXT
   (pnLOC_ID_FROM in P_BASE.tmnLOC_ID,
    pnLOC_ID_TO in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnLOCR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCR_VERSION_NBR;
    xLOCR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCR_TEXT',
      to_char(pnLOC_ID_FROM) || '~' || to_char(pnLOC_ID_TO) || '~' || psLOCRT_CODE ||
        '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) ||
        '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCR_ROWID
    from T_LOCATION_RELATIONSHIPS
    where LOC_ID_FROM = pnLOC_ID_FROM
    and LOC_ID_TO = pnLOC_ID_TO
    and LOCRT_CODE = psLOCRT_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_RELATIONSHIPS
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
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCR_TEXT;
--
-- ----------------------------------------
-- INSERT_LOC_TYPE_RELATIONSHIP
-- ----------------------------------------
--
  procedure INSERT_LOC_TYPE_RELATIONSHIP
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE)
  is
    sACTIVE_FLAG P_BASE.tsLOCRT_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOC_TYPE_RELATIONSHIP',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE);
  --
    select ACTIVE_FLAG into sACTIVE_FLAG from T_LOCATION_RELATIONSHIP_TYPES where CODE = psLOCRT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('LOC', 13, 'Inactive location relationship type');
    end if;
  --
    insert into T_LOCATION_TYPE_RELATIONSHIPS (LOCT_CODE_FROM, LOCT_CODE_TO, LOCRT_CODE)
    values (psLOCT_CODE_FROM, psLOCT_CODE_TO, psLOCRT_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOC_TYPE_RELATIONSHIP;
--
-- ----------------------------------------
-- DELETE_LOC_TYPE_RELATIONSHIP
-- ----------------------------------------
--
  procedure DELETE_LOC_TYPE_RELATIONSHIP
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCTR_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTR_VERSION_NBR;
    xLOCTR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOC_TYPE_RELATIONSHIP',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTR_ROWID
    from T_LOCATION_TYPE_RELATIONSHIPS
    where LOCT_CODE_FROM = psLOCT_CODE_FROM
    and LOCT_CODE_TO = psLOCT_CODE_TO
    and LOCRT_CODE = psLOCRT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_TYPE_RELATIONSHIPS where rowid = xLOCTR_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Location relationship type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOC_TYPE_RELATIONSHIP;
--
-- ----------------------------------------
-- SET_LOCTR_TEXT
-- ----------------------------------------
--
  procedure SET_LOCTR_TEXT
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCTR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTR_VERSION_NBR;
    xLOCTR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCTR_TEXT',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE || '~' ||
        to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTR_ROWID
    from T_LOCATION_TYPE_RELATIONSHIPS
    where LOCT_CODE_FROM = psLOCT_CODE_FROM
    and LOCT_CODE_TO = psLOCT_CODE_TO
    and LOCRT_CODE = psLOCRT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_TYPE_RELATIONSHIPS
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCTR_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCTR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCTR_TEXT
   (psLOCT_CODE_FROM in P_BASE.tmsLOCT_CODE,
    psLOCT_CODE_TO in P_BASE.tmsLOCT_CODE,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnVERSION_NBR in out P_BASE.tnLOCTR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTR_VERSION_NBR;
    xLOCTR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCTR_TEXT',
      psLOCT_CODE_FROM || '~' || psLOCT_CODE_TO || '~' || psLOCRT_CODE || '~' ||
        to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTR_ROWID
    from T_LOCATION_TYPE_RELATIONSHIPS
    where LOCT_CODE_FROM = psLOCT_CODE_FROM
    and LOCT_CODE_TO = psLOCT_CODE_TO
    and LOCRT_CODE = psLOCRT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_TYPE_RELATIONSHIPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 6, 'Location relationship has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCTR_TEXT;
--
-- ----------------------------------------
-- INSERT_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure INSERT_LOCATION_TYPE_VARIANT
   (pnID out P_BASE.tnLOCTV_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psLOCT_CODE in P_BASE.tmsLOCT_CODE,
    pnLOC_ID in P_BASE.tmnLOC_ID,
    psLOCRT_CODE in P_BASE.tmsLOCRT_CODE,
    pnDISPLAY_SEQ in P_BASE.tnLOCTV_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsLOCTV_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_LOCATION_TYPE_VARIANT',
      psLOCT_CODE || '~' || to_char(pnLOC_ID) || '~' || psLOCRT_CODE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'LOCTV', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_LOCATION_TYPE_VARIANTS
     (ID, LOCT_CODE, LOC_ID, LOCRT_CODE, DISPLAY_SEQ, ACTIVE_FLAG,
      ITM_ID)
    values
     (LOCTV_SEQ.nextval, psLOCT_CODE, pnLOC_ID, psLOCRT_CODE, pnDISPLAY_SEQ, psACTIVE_FLAG,
      nITM_ID)
    returning ID into pnID;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- UPDATE_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure UPDATE_LOCATION_TYPE_VARIANT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCTV_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCTV_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_LOCATION_TYPE_VARIANT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'LOCTV', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_LOCATION_TYPE_VARIANTS
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTV_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Location type variant has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- SET_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure SET_LOCATION_TYPE_VARIANT
   (pnID in out P_BASE.tnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psLOCT_CODE in P_BASE.tsLOCT_CODE := null,
    pnLOC_ID in P_BASE.tnLOC_ID := null,
    psLOCRT_CODE in P_BASE.tsLOCRT_CODE := null,
    pnDISPLAY_SEQ in P_BASE.tnLOCTV_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsLOCTV_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION_TYPE_VARIANT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLOCT_CODE || '~' || to_char(pnLOC_ID) || '~' || psLOCRT_CODE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_LOCATION_TYPE_VARIANT
       (pnID, psLANG_CODE, psDescription, psLOCT_CODE, pnLOC_ID, psLOCRT_CODE,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_LOCATION_TYPE_VARIANT
       (pnID, pnVERSION_NBR, psLANG_CODE, psDescription, pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- DELETE_LOCATION_TYPE_VARIANT
-- ----------------------------------------
--
  procedure DELETE_LOCATION_TYPE_VARIANT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in P_BASE.tnLOCTV_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_LOCATION_TYPE_VARIANT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_LOCATION_TYPE_VARIANTS where rowid = xLOCTV_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Location type variant has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_LOCATION_TYPE_VARIANT;
--
-- ----------------------------------------
-- SET_LOCTV_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_LOCTV_DESCRIPTION
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCTV_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_LOCTV_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCTV_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_LOCTV_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_LOCTV_DESCRIPTION
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCTV_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_LOCTV_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCTV_DESCRIPTION;
--
-- ----------------------------------------
-- SET_LOCTV_TEXT
-- ----------------------------------------
--
  procedure SET_LOCTV_TEXT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCTV_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'LOCTV', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_LOCATION_TYPE_VARIANTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTV_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Location type variant has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_LOCTV_TEXT;
--
-- ----------------------------------------
-- REMOVE_LOCTV_TEXT
-- ----------------------------------------
--
  procedure REMOVE_LOCTV_TEXT
   (pnID in P_BASE.tmnLOCTV_ID,
    pnVERSION_NBR in out P_BASE.tnLOCTV_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnLOCTV_VERSION_NBR;
    xLOCTV_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_LOCTV_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xLOCTV_ROWID
    from T_LOCATION_TYPE_VARIANTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_LOCATION_TYPE_VARIANTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xLOCTV_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('LOC', 999, 'Location type variant has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_LOCTV_TEXT;
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
  into gsCOUNTRY_LOCAT_CODE
  from T_SYSTEM_PARAMETERS
  where CODE = 'COUNTRY LOCAT CODE';
--
  select NUM_VALUE
  into gnLOC_ID_MULTIPLIER
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID MULTIPLIER';
--
  select NUM_VALUE
  into gnLOC_ID_INCREMENT
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID INCREMENT';
--
  select NUM_VALUE
  into gnLOC_ID_CHECK_MULTIPLIER
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID CHECK MULTIPLIER';
--
  select NUM_VALUE
  into gnLOC_ID_CHECK_INCREMENT
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID CHECK INCREMENT';
--
  select NUM_VALUE
  into gnLOC_ID_CHECK_MODULUS
  from T_SYSTEM_PARAMETERS
  where CODE = 'LOCATION ID CHECK MODULUS';
--
end P_LOCATION;
/

show errors
