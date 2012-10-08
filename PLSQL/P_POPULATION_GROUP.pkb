create or replace package body P_POPULATION_GROUP is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_POPULATION_GROUP
-- ----------------------------------------
--
  procedure INSERT_POPULATION_GROUP
   (pnID out P_BASE.tnPGR_ID,
    psDST_CODE in P_BASE.tsDST_CODE := null,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    psSEX_CODE in P_BASE.tsSEX_CODE := null,
    pnAGR_ID in P_BASE.tnAGR_ID := null,
    pnPER_ID in P_BASE.tnPER_ID := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUBGROUP_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := null)
  is
    nPGR_SEQ_NBR_MAX P_BASE.tnPGR_SEQ_NBR := null;
    nITM_ID P_BASE.tnITM_ID := null;
    nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR := null;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_POPULATION_GROUP',
      psDST_CODE || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnPER_ID) || '~' || psLANG_CODE || '~' ||
        to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME || '~' || to_char(pnPPG_ID));
  --
    if psSUBGROUP_NAME is not null
    then
      select nvl(max(SEQ_NBR), 0) + 1
      into nPGR_SEQ_NBR_MAX
      from T_POPULATION_GROUPS
      where nvl(DST_CODE, 'x') = nvl(psDST_CODE, 'x')
      and nvl(LOC_ID_ASYLUM_COUNTRY, 0) = nvl(pnLOC_ID_ASYLUM_COUNTRY, 0)
      and nvl(LOC_ID_ASYLUM, 0) = nvl(pnLOC_ID_ASYLUM, 0)
      and nvl(LOC_ID_ORIGIN_COUNTRY, 0) = nvl(pnLOC_ID_ORIGIN_COUNTRY, 0)
      and nvl(LOC_ID_ORIGIN, 0) = nvl(pnLOC_ID_ORIGIN, 0)
      and nvl(DIM_ID1, 0) = nvl(pnDIM_ID1, 0)
      and nvl(DIM_ID2, 0) = nvl(pnDIM_ID2, 0)
      and nvl(DIM_ID3, 0) = nvl(pnDIM_ID3, 0)
      and nvl(DIM_ID4, 0) = nvl(pnDIM_ID4, 0)
      and nvl(DIM_ID5, 0) = nvl(pnDIM_ID5, 0)
      and nvl(SEX_CODE, 'x') = nvl(psSEX_CODE, 'x')
      and nvl(AGR_ID, 0) = nvl(pnAGR_ID, 0)
      and nvl(PER_ID, 0) = nvl(pnPER_ID, 0)
      ;
    --
      P_TEXT.SET_TEXT(nITM_ID, 'PGR', 'PSGRNAME', nTXT_SEQ_NBR, psLANG_CODE, psSUBGROUP_NAME);
    end if;
  --
    insert into T_POPULATION_GROUPS
     (ID, DST_CODE,
      LOC_ID_ASYLUM_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN_COUNTRY, LOC_ID_ORIGIN,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5, SEX_CODE, AGR_ID, PER_ID,
      SEQ_NBR, PPG_ID, ITM_ID)
    values
     (PGR_SEQ.nextval, psDST_CODE,
      pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID, pnPER_ID,
      nPGR_SEQ_NBR_MAX, pnPPG_ID, nITM_ID)
    returning ID into pnID;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_POPULATION_GROUP;
--
-- ----------------------------------------
-- UPDATE_POPULATION_GROUP
-- ----------------------------------------
--
  procedure UPDATE_POPULATION_GROUP
   (pnID in P_BASE.tmnPGR_ID,
    pnVERSION_NBR in out P_BASE.tnPGR_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUBGROUP_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := -1)
  is
    nPGR_SEQ_NBR P_BASE.tnPGR_SEQ_NBR;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGR_VERSION_NBR;
    xPGR_ROWID rowid;
    nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_POPULATION_GROUP',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME || '~' ||
        to_char(pnPPG_ID));
  --
    select SEQ_NBR, ITM_ID, VERSION_NBR, rowid
    into nPGR_SEQ_NBR, nITM_ID, nVERSION_NBR, xPGR_ROWID
    from T_POPULATION_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psSUBGROUP_NAME is not null
      then
        if nPGR_SEQ_NBR is not null
        then P_TEXT.SET_TEXT(nITM_ID, 'PGR', 'PSGRNAME', nTXT_SEQ_NBR, psLANG_CODE, psSUBGROUP_NAME);
        else P_MESSAGE.DISPLAY_MESSAGE('PGR', 4, 'Population group has no subgroup');
        end if;
      end if;
    --
      update T_POPULATION_GROUPS
      set PPG_ID = case when pnPPG_ID = -1 then PPG_ID else pnPPG_ID end,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 1, 'Population group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_POPULATION_GROUP;
--
-- ----------------------------------------
-- SET_POPULATION_GROUP
-- ----------------------------------------
--
  procedure SET_POPULATION_GROUP
   (pnID in out P_BASE.tnPGR_ID,
    pnVERSION_NBR in out P_BASE.tnPGR_VERSION_NBR,
    psDST_CODE in P_BASE.tsDST_CODE := null,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    psSEX_CODE in P_BASE.tsSEX_CODE := null,
    pnAGR_ID in P_BASE.tnAGR_ID := null,
    pnPER_ID in P_BASE.tnPER_ID := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUBGROUP_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := -1)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPULATION_GROUP',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psDST_CODE || '~' ||
        to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' || to_char(pnLOC_ID_ORIGIN) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psSEX_CODE || '~' ||
        to_char(pnAGR_ID) || '~' || to_char(pnPER_ID) || '~' || psLANG_CODE || '~' ||
        to_char(length(psSUBGROUP_NAME)) || ':' || psSUBGROUP_NAME || '~' || to_char(pnPPG_ID));
  --
    if pnVERSION_NBR is null
    then
      INSERT_POPULATION_GROUP
       (pnID, psDST_CODE,
        pnLOC_ID_ASYLUM_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN_COUNTRY, pnLOC_ID_ORIGIN,
        pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, psSEX_CODE, pnAGR_ID, pnPER_ID,
        psLANG_CODE, psSUBGROUP_NAME, pnPPG_ID);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_POPULATION_GROUP(pnID, pnVERSION_NBR, psLANG_CODE, psSUBGROUP_NAME, pnPPG_ID);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_POPULATION_GROUP;
--
-- ----------------------------------------
-- DELETE_POPULATION_GROUP
-- ----------------------------------------
--
  procedure DELETE_POPULATION_GROUP
   (pnID in P_BASE.tmnPGR_ID,
    pnVERSION_NBR in P_BASE.tnPGR_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGR_VERSION_NBR;
    xPGR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_POPULATION_GROUP',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGR_ROWID
    from T_POPULATION_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPULATION_GROUPS where rowid = xPGR_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 1, 'Population group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_POPULATION_GROUP;
--
-- ----------------------------------------
-- SET_PGR_TEXT
-- ----------------------------------------
--
  procedure SET_PGR_TEXT
   (pnID in P_BASE.tmnPGR_ID,
    pnVERSION_NBR in out P_BASE.tnPGR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGR_VERSION_NBR;
    xPGR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PGR_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGR_ROWID
    from T_POPULATION_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PGR', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPULATION_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 1, 'Population group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_PGR_TEXT;
--
-- ----------------------------------------
-- REMOVE_PGR_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PGR_TEXT
   (pnID in P_BASE.tmnPGR_ID,
    pnVERSION_NBR in out P_BASE.tnPGR_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGR_VERSION_NBR;
    xPGR_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PGR_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGR_ROWID
    from T_POPULATION_GROUPS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPULATION_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGR_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 1, 'Population group has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PGR_TEXT;
--
-- ----------------------------------------
-- INSERT_PGR_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure INSERT_PGR_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPGRAT_CODE,
    psDATA_TYPE in P_BASE.tmsPGRAT_DATA_TYPE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnPGRAT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsPGRAT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PGR_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'PGRAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_POP_GROUP_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_PGR_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- UPDATE_PGR_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_PGR_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsPGRAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPGRAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPGRAT_ACTIVE_FLAG := null)
  is
    sDATA_TYPE P_BASE.tsPGRAT_DATA_TYPE;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRAT_VERSION_NBR;
    xPGRAT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_PGR_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, ITM_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nITM_ID, nVERSION_NBR, xPGRAT_ROWID
    from T_POP_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check if data type is to be changed and population group attributes of this type already
    --  exist.
    --
      if psDATA_TYPE != sDATA_TYPE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x' into sDummy from T_POP_GROUP_ATTRIBUTES where PGRAT_CODE = psCODE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('PGR', 5, 'Cannot update data type of population group attribute type already in use');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'PGRAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_POP_GROUP_ATTRIBUTE_TYPES
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGRAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 2, 'Population group attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PGR_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_PGR_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_PGR_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsPGRAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPGRAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPGRAT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PGR_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_PGR_ATTRIBUTE_TYPE
       (psCODE, psDATA_TYPE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_PGR_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psDATA_TYPE, psLANG_CODE, psDescription,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_PGR_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_PGR_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_PGR_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in P_BASE.tnPGRAT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRAT_VERSION_NBR;
    xPGRAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_PGR_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGRAT_ROWID
    from T_POP_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POP_GROUP_ATTRIBUTE_TYPES where rowid = xPGRAT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 2, 'Population group attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_PGR_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_PGRAT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PGRAT_DESCRIPTION
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PGRAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PGRAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_PGRAT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PGRAT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PGRAT_DESCRIPTION
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PGRAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_PGRAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PGRAT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PGRAT_TEXT
-- ----------------------------------------
--
  procedure SET_PGRAT_TEXT
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRAT_VERSION_NBR;
    xPGRAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PGRAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGRAT_ROWID
    from T_POP_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PGRAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POP_GROUP_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGRAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 2, 'Population group attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_PGRAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_PGRAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PGRAT_TEXT
   (psCODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRAT_VERSION_NBR;
    xPGRAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PGRAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGRAT_ROWID
    from T_POP_GROUP_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POP_GROUP_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGRAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 2, 'Population group attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PGRAT_TEXT;
--
-- ----------------------------------------
-- INSERT_PGR_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_PGR_ATTRIBUTE
   (pnPGR_ID in P_BASE.tmnPGR_ID,
    psPGRAT_CODE in P_BASE.tmsPGRAT_CODE,
    psCHAR_VALUE in P_BASE.tsPGRA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnPGRA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdPGRA_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsPGRAT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsPGRAT_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_PGR_ATTRIBUTE',
      to_char(pnPGR_ID) || '~' || psPGRAT_CODE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from T_POP_GROUP_ATTRIBUTE_TYPES
    where CODE = psPGRAT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('PGR', 6, 'Inactive population group attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE('PGR', 7, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into T_POP_GROUP_ATTRIBUTES (PGR_ID, PGRAT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (pnPGR_ID, psPGRAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_PGR_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_PGR_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_PGR_ATTRIBUTE
   (pnPGR_ID in P_BASE.tmnPGR_ID,
    psPGRAT_CODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsPGRA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnPGRA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdPGRA_DATE_VALUE := null)
  is
    sCHAR_VALUE P_BASE.tsPGRA_CHAR_VALUE;
    nVERSION_NBR P_BASE.tnPGRA_VERSION_NBR;
    xPGRA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_PGR_ATTRIBUTE',
      to_char(pnPGR_ID) || '~' || psPGRAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select CHAR_VALUE, VERSION_NBR, rowid
    into sCHAR_VALUE, nVERSION_NBR, xPGRA_ROWID
    from T_POP_GROUP_ATTRIBUTES
    where PGR_ID = pnPGR_ID
    and PGRAT_CODE = psPGRAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update T_POP_GROUP_ATTRIBUTES
      set CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGRA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 3, 'Population group attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_PGR_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_PGR_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_PGR_ATTRIBUTE
   (pnPGR_ID in P_BASE.tmnPGR_ID,
    psPGRAT_CODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsPGRA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnPGRA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdPGRA_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PGR_ATTRIBUTE',
      to_char(pnPGR_ID) || '~' || psPGRAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_PGR_ATTRIBUTE
       (pnPGR_ID, psPGRAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_PGR_ATTRIBUTE
       (pnPGR_ID, psPGRAT_CODE, pnVERSION_NBR, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_PGR_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_PGR_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_PGR_ATTRIBUTE
   (pnPGR_ID in P_BASE.tmnPGR_ID,
    psPGRAT_CODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in P_BASE.tnPGRA_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRA_VERSION_NBR;
    xPGRA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_PGR_ATTRIBUTE',
      to_char(pnPGR_ID) || '~' || psPGRAT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGRA_ROWID
    from T_POP_GROUP_ATTRIBUTES
    where PGR_ID = pnPGR_ID
    and PGRAT_CODE = psPGRAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POP_GROUP_ATTRIBUTES where rowid = xPGRA_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 3, 'Population group attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_PGR_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_PGRA_TEXT
-- ----------------------------------------
--
  procedure SET_PGRA_TEXT
   (pnPGR_ID in P_BASE.tmnPGR_ID,
    psPGRAT_CODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRA_VERSION_NBR;
    xPGRA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PGRA_TEXT',
      to_char(pnPGR_ID) || '~' || psPGRAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGRA_ROWID
    from T_POP_GROUP_ATTRIBUTES
    where PGR_ID = pnPGR_ID
    and PGRAT_CODE = psPGRAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PGRA', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POP_GROUP_ATTRIBUTES
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGRA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 3, 'Population group attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end SET_PGRA_TEXT;
--
-- ----------------------------------------
-- REMOVE_PGRA_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PGRA_TEXT
   (pnPGR_ID in P_BASE.tmnPGR_ID,
    psPGRAT_CODE in P_BASE.tmsPGRAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPGRA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPGRA_VERSION_NBR;
    xPGRA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PGRA_TEXT',
      to_char(pnPGR_ID) || '~' || psPGRAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPGRA_ROWID
    from T_POP_GROUP_ATTRIBUTES
    where PGR_ID = pnPGR_ID
    and PGRAT_CODE = psPGRAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POP_GROUP_ATTRIBUTES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPGRA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PGR', 3, 'Population group attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end REMOVE_PGRA_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'PGR'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_POPULATION_GROUP;
/

show errors
