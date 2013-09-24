create or replace package body P_POPULATION_PLANNING_GROUP is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_PPG (1)
-- ----------------------------------------
--
  procedure INSERT_PPG
   (pnID out P_BASE.tnPPG_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnLOC_ID in P_BASE.tmnLOC_ID,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PPG-1',
      to_char(pnLOC_ID) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check that the associated location is an operation and is active for the whole of the given
  --  effective date range.
  --
    declare
      sLOCT_CODE P_BASE.tsLOCT_CODE;
    begin
      select LOCT_CODE
      into sLOCT_CODE
      from T_LOCATIONS
      where ID = pnLOC_ID
      and START_DATE <= nvl(pdSTART_DATE, P_BASE.gdMIN_DATE)
      and END_DATE >= nvl(pdEND_DATE, P_BASE.gdMAX_DATE);
    --
      if sLOCT_CODE not in ('HCR-COP', 'HCR-ROF')
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'PPG location is not an operation');
      end if;
    end;
  --
  -- Check for an existing PPG with the same code and overlapping effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from T_POPULATION_PLANNING_GROUPS
      where PPG_CODE = psPPG_CODE
      and START_DATE < nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
      and END_DATE > nvl(pdSTART_DATE, P_BASE.gdMIN_DATE);
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'PPG with overlapping dates already exists');
    end;
  --
    P_TEXT.SET_TEXT(nITM_ID, 'PPG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_POPULATION_PLANNING_GROUPS
     (ID, LOC_ID, PPG_CODE,
      START_DATE, END_DATE, ITM_ID)
    values
     (PPG_SEQ.nextval, pnLOC_ID, psPPG_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), nITM_ID)
    returning ID into pnID;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PPG;
--
-- ----------------------------------------
-- INSERT_PPG (2)
-- ----------------------------------------
--
  procedure INSERT_PPG
   (pnID out P_BASE.tnPPG_ID,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psCountryCode in P_BASE.tmsCountryCode,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    nLOC_ID P_BASE.tnLOC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PPG-2',
      psCountryCode || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check if there exists a country operation for the given country which is active for the whole
  --  of the given effective date range, and create one if not.
  --
    begin
      select ID
      into nLOC_ID
      from T_LOCATION_ATTRIBUTES LOCA
      inner join T_LOCATIONS LOC
        on LOC.ID = LOCA.LOC_ID
        and LOC.LOCT_CODE = 'HCR-COP'
        and LOC.START_DATE <= nvl(pdSTART_DATE, P_BASE.gdMIN_DATE)
        and LOC.END_DATE >= nvl(pdEND_DATE, P_BASE.gdMAX_DATE)
      where LOCA.LOCAT_CODE = 'HCRCD'
      and LOCA.CHAR_VALUE = psCountryCode;
    exception
      when NO_DATA_FOUND
      then
        CREATE_COUNTRY_OPERATION(nLOC_ID, psCountryCode);
      --
        for rCOU in
         (select LOC.ID, LOC.START_DATE, LOC.END_DATE
          from T_LOCATION_ATTRIBUTES LOCA
          inner join T_LOCATIONS LOC
            on LOC.ID = LOCA.LOC_ID
            and LOC.LOCT_CODE = 'COUNTRY'
          where LOCA.LOCAT_CODE = 'ISO3166A3'
          and LOCA.CHAR_VALUE = psCountryCode)
        loop
          P_LOCATION.INSERT_LOCATION_RELATIONSHIP
           (nLOC_ID, rCOU.ID, 'HCRRESP', rCOU.START_DATE, rCOU.END_DATE);
        end loop;
    end;
  --
    INSERT_PPG(pnID, psLANG_CODE, psDescription, nLOC_ID, psPPG_CODE, pdSTART_DATE, pdEND_DATE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_PPG;
--
-- ----------------------------------------
-- UPDATE_PPG
-- ----------------------------------------
--
  procedure UPDATE_PPG
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnLOC_ID in P_BASE.tnLOC_ID := null,
    psPPG_CODE in P_BASE.tsPPG_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    nLOC_ID P_BASE.tnLOC_ID;
    sPPG_CODE P_BASE.tsPPG_CODE;
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_PPG',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||to_char(pnLOC_ID) || '~' ||
        psPPG_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select LOC_ID, PPG_CODE, START_DATE, END_DATE, ITM_ID, VERSION_NBR, rowid
    into nLOC_ID, sPPG_CODE, dSTART_DATE, dEND_DATE, nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
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
    -- If associated location or dates are being changed, check that the location is active for the
    --   whole of the effective date range.
    --
      if pnLOC_ID != nLOC_ID or dSTART_DATE_NEW != dSTART_DATE or dEND_DATE_NEW != dEND_DATE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_LOCATIONS
          where ID = pnLOC_ID
          and START_DATE < dSTART_DATE_NEW
          and END_DATE > dEND_DATE_NEW;
        end;
      end if;
    --
    -- If dates are being changed, check for PPG with the same code and overlapping effective dates.
    --
      if dSTART_DATE_NEW != dSTART_DATE or dEND_DATE_NEW != dEND_DATE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from T_POPULATION_PLANNING_GROUPS
          where PPG_CODE = psPPG_CODE
          and START_DATE < dEND_DATE_NEW
          and END_DATE > dSTART_DATE_NEW
          and ID != pnID;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'PPG with overlapping dates already exists');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'PPG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_POPULATION_PLANNING_GROUPS
      set LOC_ID = nvl(pnLOC_ID, LOC_ID),
        PPG_CODE = nvl(psPPG_CODE, PPG_CODE),
        START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PPG;
--
-- ----------------------------------------
-- SET_PPG
-- ----------------------------------------
--
  procedure SET_PPG
   (pnID in out P_BASE.tnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnLOC_ID in P_BASE.tnLOC_ID := null,
    psPPG_CODE in P_BASE.tsPPG_CODE := null,
    pdSTART_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_LOCATION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||to_char(pnLOC_ID) || '~' ||
        psPPG_CODE || '~' || to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_PPG(pnID, psLANG_CODE, psDescription, pnLOC_ID, psPPG_CODE,
                 case when pdSTART_DATE = P_BASE.gdFALSE_DATE then null else pdSTART_DATE end,
                 case when pdEND_DATE = P_BASE.gdFALSE_DATE then null else pdEND_DATE end);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_PPG(pnID, pnVERSION_NBR, psLANG_CODE, psDescription, pnLOC_ID, psPPG_CODE,
                 pdSTART_DATE, pdEND_DATE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PPG;
--
-- ----------------------------------------
-- DELETE_PPG
-- ----------------------------------------
--
  procedure DELETE_PPG
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in P_BASE.tnPPG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_SYSTEM_PARAMETER',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPULATION_PLANNING_GROUPS where rowid = xPPG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_PPG;
--
-- ----------------------------------------
-- SET_PPG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PPG_DESCRIPTION
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PPG_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PPG_TEXT(pnID, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PPG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PPG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PPG_DESCRIPTION
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PPG_DESCRIPTION',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE);
  --
    REMOVE_PPG_TEXT(pnID, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PPG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PPG_TEXT
-- ----------------------------------------
--
  procedure SET_PPG_TEXT
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PPG_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PPG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPULATION_PLANNING_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_PPG_TEXT;
--
-- ----------------------------------------
-- REMOVE_PPG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PPG_TEXT
   (pnID in P_BASE.tmnPPG_ID,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PPG_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPPG_ROWID
    from T_POPULATION_PLANNING_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPULATION_PLANNING_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'PPG has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PPG_TEXT;
--
-- ----------------------------------------
-- CREATE_COUNTRY_OPERATION
-- ----------------------------------------
--
  procedure CREATE_COUNTRY_OPERATION
   (pnID out P_BASE.tnLOC_ID,
    psCountryCode in P_BASE.tmsCountryCode)
  is
    dSTART_DATE P_BASE.tdDate;
    dEND_DATE P_BASE.tdDate;
    nLOC_ID_COUNTRY P_BASE.tnLOC_ID;
    nLOC_ID_OPERATION P_BASE.tnLOC_ID;
    nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.CREATE_COUNTRY_OPERATION', psCountryCode);
  --
    begin
      with Q_COU as
       (select LOCA.CHAR_VALUE as COU_CODE, LOC.START_DATE, LOC.END_DATE, LOC.ID as LOC_ID
        from T_LOCATION_ATTRIBUTES LOCA
        inner join T_LOCATIONS LOC
          on LOC.ID = LOCA.LOC_ID
          and LOC.LOCT_CODE = 'COUNTRY'
        where LOCA.LOCAT_CODE = 'ISO3166A3'
        and LOCA.CHAR_VALUE = psCountryCode),
      --
      Q_CCOU (COU_CODE, START_DATE, END_DATE, LOC_ID) as
       (select COU.COU_CODE, COU.START_DATE, COU.END_DATE, COU.LOC_ID
        from Q_COU COU
        where not exists
         (select null
          from Q_COU COU1
          where COU1.COU_CODE = COU.COU_CODE
          and COU1.END_DATE = COU.START_DATE)
        union all
        select CCOU.COU_CODE, CCOU.START_DATE, COU.END_DATE, COU.LOC_ID
        from Q_CCOU CCOU
        inner join Q_COU COU
          on COU.COU_CODE = CCOU.COU_CODE
          and COU.START_DATE = CCOU.END_DATE)
      --
      select START_DATE, END_DATE, LOC_ID
      into dSTART_DATE, dEND_DATE, nLOC_ID_COUNTRY
      from
       (select COU_CODE, START_DATE, END_DATE, LOC_ID,
          row_number() over (partition by COU_CODE, START_DATE order by END_DATE desc) as SEQ_NBR
        from Q_CCOU)
      where SEQ_NBR = 1;
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 4, 'No country with this code');
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 999, 'Multiple country instances with this code');
    end;
  --
    for rCOU in
     (select TXT.LANG_CODE, TXT.TEXT as NAME
      from T_LOCATIONS LOC
      inner join T_TEXT_ITEMS TXT
        on TXT.ITM_ID = LOC.ITM_ID
        and TXT.TXTT_CODE = 'NAME'
        and TXT.SEQ_NBR = 1
      where LOC.ID = nLOC_ID_COUNTRY)
    loop
      if nLOC_ID_OPERATION is null
      then
        P_LOCATION.INSERT_LOCATION
         (nLOC_ID_OPERATION, rCOU.LANG_CODE, rCOU.NAME, 'HCR-COP', null, dSTART_DATE, dEND_DATE);
      --
        P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_OPERATION, 'HCRCD', psCountryCode);
      --
        nVERSION_NBR := 1;
      else
        P_LOCATION.SET_LOC_NAME(nLOC_ID_OPERATION, nVERSION_NBR, rCOU.LANG_CODE, rCOU.NAME);
      end if;
    end loop;
  --
    pnID := nLOC_ID_OPERATION;
  --
    P_UTILITY.TRACE_CONTEXT(to_char(pnID) || '~' || psCountryCode);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end CREATE_COUNTRY_OPERATION;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'PPG'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_POPULATION_PLANNING_GROUP;
/

show errors
