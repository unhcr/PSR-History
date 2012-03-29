create or replace package body P_POPULATION_PLANNING_GROUP is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_PPG
-- ----------------------------------------
--
  procedure INSERT_PPG
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pdSTART_DATE in P_BASE.tdDate := null,
    pdEND_DATE in P_BASE.tdDate := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PPG',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
  -- Check that the associated location is active for the whole of the given effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from LOCATIONS
      where CODE = pnLOC_CODE
      and START_DATE <= pdSTART_DATE
      and END_DATE >= pdEND_DATE;
    end;
  --
  -- Check for an existing PPG with the same code and overlapping effective date range.
  --
    declare
      sDummy varchar2(1);
    begin
      select 'x'
      into sDummy
      from POPULATION_PLANNING_GROUPS
      where LOC_CODE = pnLOC_CODE
      and PPG_CODE = psPPG_CODE
      and START_DATE <= pdEND_DATE
      and END_DATE >= pdSTART_DATE;
    --
      raise TOO_MANY_ROWS;
    exception
      when NO_DATA_FOUND then null;
    --
      when TOO_MANY_ROWS
      then P_MESSAGE.DISPLAY_MESSAGE('PPG', 2, 'PPG with overlapping dates already exists');
    end;
  --
    P_TEXT.SET_TEXT(nTXT_ID, 'PPG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into POPULATION_PLANNING_GROUPS
     (LOC_CODE, PPG_CODE,
      START_DATE, END_DATE, TXT_ID)
    values
     (pnLOC_CODE, psPPG_CODE,
      nvl(pdSTART_DATE, P_BASE.gdMIN_DATE), nvl(pdEND_DATE, P_BASE.gdMAX_DATE), nTXT_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_PPG;
--
-- ----------------------------------------
-- UPDATE_PPG
-- ----------------------------------------
--
  procedure UPDATE_PPG
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pdSTART_DATE_NEW in P_BASE.tdDate := P_BASE.gdFALSE_DATE,
    pdEND_DATE in P_BASE.tdDate := P_BASE.gdFALSE_DATE)
  is
    dEND_DATE P_BASE.tdDate;
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
    dSTART_DATE_NEW P_BASE.tdDate;
    dEND_DATE_NEW P_BASE.tdDate;
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_PPG',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        to_char(pdSTART_DATE_NEW, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        to_char(pdEND_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select END_DATE, TXT_ID, VERSION_NBR, rowid
    into dEND_DATE, nTXT_ID, nVERSION_NBR, xPPG_ROWID
    from POPULATION_PLANNING_GROUPS
    where LOC_CODE = pnLOC_CODE
    and PPG_CODE = psPPG_CODE
    and START_DATE = pdSTART_DATE
    for update;
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
    -- If dates are being changed, check for PPG with the same code and overlapping effective dates.
    --
      if dSTART_DATE_NEW != pdSTART_DATE or dEND_DATE_NEW != dEND_DATE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x'
          into sDummy
          from POPULATION_PLANNING_GROUPS
          where LOC_CODE = pnLOC_CODE
          and PPG_CODE = psPPG_CODE
          and START_DATE <= dEND_DATE_NEW
          and END_DATE >= dSTART_DATE_NEW
          and START_DATE != pdSTART_DATE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('PPG', 2, 'Overlapping PPG already exists');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nTXT_ID, 'PPG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update POPULATION_PLANNING_GROUPS
      set START_DATE = dSTART_DATE_NEW,
        END_DATE = dEND_DATE_NEW,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PPG', 1, 'PPG has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_PPG;
--
-- ----------------------------------------
-- DELETE_PPG
-- ----------------------------------------
--
  procedure DELETE_PPG
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in P_BASE.tnPPG_VERSION_NBR)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_SYSTEM_PARAMETER',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR));
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPPG_ROWID
    from POPULATION_PLANNING_GROUPS
    where LOC_CODE = pnLOC_CODE
    and PPG_CODE = psPPG_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from POPULATION_PLANNING_GROUPS where rowid = xPPG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nTXT_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('PPG', 1, 'PPG has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_PPG;
--
-- ----------------------------------------
-- SET_PPG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PPG_DESCRIPTION
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXI_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PPG_DESCRIPTION',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PPG_TEXT(pnLOC_CODE, psPPG_CODE, pdSTART_DATE, pnVERSION_NBR,
                 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PPG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PPG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PPG_DESCRIPTION
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PPG_DESCRIPTION',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        psLANG_CODE);
  --
    REMOVE_PPG_TEXT(pnLOC_CODE, psPPG_CODE, pdSTART_DATE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PPG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PPG_TEXT
-- ----------------------------------------
--
  procedure SET_PPG_TEXT
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PPG_TEXT',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPPG_ROWID
    from POPULATION_PLANNING_GROUPS
    where LOC_CODE = pnLOC_CODE
    and PPG_CODE = psPPG_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nTXT_ID, 'PPG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update POPULATION_PLANNING_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PPG', 1, 'PPG has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PPG_TEXT;
--
-- ----------------------------------------
-- REMOVE_PPG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PPG_TEXT
   (pnLOC_CODE in P_BASE.tmnLOC_CODE,
    psPPG_CODE in P_BASE.tmsPPG_CODE,
    pdSTART_DATE in P_BASE.tmdDate,
    pnVERSION_NBR in out P_BASE.tnPPG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nTXT_ID P_BASE.tnTXT_ID;
    nVERSION_NBR P_BASE.tnPPG_VERSION_NBR;
    xPPG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PPG_TEXT',
      to_char(pnLOC_CODE) || '~' || psPPG_CODE || '~' ||
        to_char(pdSTART_DATE, 'YYYY-MM-DD HH24:MI:SS') || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select TXT_ID, VERSION_NBR, rowid
    into nTXT_ID, nVERSION_NBR, xPPG_ROWID
    from POPULATION_PLANNING_GROUPS
    where LOC_CODE = pnLOC_CODE
    and PPG_CODE = psPPG_CODE
    and START_DATE = pdSTART_DATE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update POPULATION_PLANNING_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPPG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PPG', 1, 'PPG has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PPG_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'PPG'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_POPULATION_PLANNING_GROUP;
/

show errors
