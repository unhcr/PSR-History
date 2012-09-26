create or replace package body P_POPULATION_SEGMENT is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_POPULATION_SEGMENT
-- ----------------------------------------
--
  procedure INSERT_POPULATION_SEGMENT
   (pnID out P_BASE.tnPSG_ID,
    psDST_CODE in P_BASE.tmsDST_CODE,
    pnLOC_ID_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnLOC_ID_SOURCE in P_BASE.tnLOC_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUB_SEGMENT_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := null)
  is
    nPSG_SEQ_NBR_MAX P_BASE.tnPSG_SEQ_NBR := null;
    nITM_ID P_BASE.tnITM_ID := null;
    nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR := null;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_POPULATION_SEGMENT',
      psDST_CODE || '~' || to_char(pnLOC_ID_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN) || '~' || to_char(pnLOC_ID_SOURCE) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psLANG_CODE || '~' ||
        to_char(length(psSUB_SEGMENT_NAME)) || ':' || psSUB_SEGMENT_NAME || '~' ||
        to_char(pnPPG_ID));
  --
    if psSUB_SEGMENT_NAME is not null
    then
      select nvl(max(SEQ_NBR), 0) + 1
      into nPSG_SEQ_NBR_MAX
      from T_POPULATION_SEGMENTS
      where DST_CODE = psDST_CODE
      and nvl(LOC_ID_COUNTRY, 0) = nvl(pnLOC_ID_COUNTRY, 0)
      and nvl(LOC_ID_ASYLUM, 0) = nvl(pnLOC_ID_ASYLUM, 0)
      and nvl(LOC_ID_ORIGIN, 0) = nvl(pnLOC_ID_ORIGIN, 0)
      and nvl(LOC_ID_SOURCE, 0) = nvl(pnLOC_ID_SOURCE, 0)
      and nvl(DIM_ID1, 0) = nvl(pnDIM_ID1, 0)
      and nvl(DIM_ID2, 0) = nvl(pnDIM_ID2, 0)
      and nvl(DIM_ID3, 0) = nvl(pnDIM_ID3, 0)
      and nvl(DIM_ID4, 0) = nvl(pnDIM_ID4, 0)
      and nvl(DIM_ID5, 0) = nvl(pnDIM_ID5, 0);
    --
      P_TEXT.SET_TEXT(nITM_ID, 'PSG', 'PSSGNAME', nTXT_SEQ_NBR, psLANG_CODE, psSUB_SEGMENT_NAME);
    end if;
  --
    insert into T_POPULATION_SEGMENTS
     (ID, DST_CODE,
      LOC_ID_COUNTRY, LOC_ID_ASYLUM, LOC_ID_ORIGIN, LOC_ID_SOURCE,
      DIM_ID1, DIM_ID2, DIM_ID3, DIM_ID4, DIM_ID5, SEQ_NBR, PPG_ID, ITM_ID)
    values
     (PSG_SEQ.nextval, psDST_CODE,
      pnLOC_ID_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN, pnLOC_ID_SOURCE,
      pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5, nPSG_SEQ_NBR_MAX, pnPPG_ID, nITM_ID)
    returning ID into pnID;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_POPULATION_SEGMENT;
--
-- ----------------------------------------
-- UPDATE_POPULATION_SEGMENT
-- ----------------------------------------
--
  procedure UPDATE_POPULATION_SEGMENT
   (pnID in P_BASE.tmnPSG_ID,
    pnVERSION_NBR in out P_BASE.tnPSG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUB_SEGMENT_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := -1)
  is
    nPSG_SEQ_NBR P_BASE.tnPSG_SEQ_NBR;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSG_VERSION_NBR;
    xPSG_ROWID rowid;
    nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_POPULATION_SEGMENT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psSUB_SEGMENT_NAME)) || ':' || psSUB_SEGMENT_NAME || '~' ||
        to_char(pnPPG_ID));
  --
    select SEQ_NBR, ITM_ID, VERSION_NBR, rowid
    into nPSG_SEQ_NBR, nITM_ID, nVERSION_NBR, xPSG_ROWID
    from T_POPULATION_SEGMENTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psSUB_SEGMENT_NAME is not null
      then
        if nPSG_SEQ_NBR is not null
        then P_TEXT.SET_TEXT(nITM_ID, 'PSG', 'PSSGNAME', nTXT_SEQ_NBR, psLANG_CODE, psSUB_SEGMENT_NAME);
        else P_MESSAGE.DISPLAY_MESSAGE('PSG', 4, 'Population segment has no sub-segment');
        end if;
      end if;
    --
      update T_POPULATION_SEGMENTS
      set PPG_ID = case when pnPPG_ID = -1 then PPG_ID else pnPPG_ID end,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 1, 'Population segment has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_POPULATION_SEGMENT;
--
-- ----------------------------------------
-- SET_POPULATION_SEGMENT
-- ----------------------------------------
--
  procedure SET_POPULATION_SEGMENT
   (pnID in out P_BASE.tnPSG_ID,
    pnVERSION_NBR in out P_BASE.tnPSG_VERSION_NBR,
    psDST_CODE in P_BASE.tsDST_CODE := null,
    pnLOC_ID_COUNTRY in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ASYLUM in P_BASE.tnLOC_ID := null,
    pnLOC_ID_ORIGIN in P_BASE.tnLOC_ID := null,
    pnLOC_ID_SOURCE in P_BASE.tnLOC_ID := null,
    pnDIM_ID1 in P_BASE.tnDIM_ID := null,
    pnDIM_ID2 in P_BASE.tnDIM_ID := null,
    pnDIM_ID3 in P_BASE.tnDIM_ID := null,
    pnDIM_ID4 in P_BASE.tnDIM_ID := null,
    pnDIM_ID5 in P_BASE.tnDIM_ID := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psSUB_SEGMENT_NAME in P_BASE.tsText := null,
    pnPPG_ID in P_BASE.tnPPG_ID := -1)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPULATION_SEGMENT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psDST_CODE || '~' ||
        to_char(pnLOC_ID_COUNTRY) || '~' || to_char(pnLOC_ID_ASYLUM) || '~' ||
        to_char(pnLOC_ID_ORIGIN) || '~' || to_char(pnLOC_ID_SOURCE) || '~' ||
        to_char(pnDIM_ID1) || '~' || to_char(pnDIM_ID2) || '~' || to_char(pnDIM_ID3) || '~' ||
        to_char(pnDIM_ID4) || '~' || to_char(pnDIM_ID5) || '~' || psLANG_CODE || '~' ||
        to_char(length(psSUB_SEGMENT_NAME)) || ':' || psSUB_SEGMENT_NAME || '~' ||
        to_char(pnPPG_ID));
  --
    if pnVERSION_NBR is null
    then
      INSERT_POPULATION_SEGMENT
       (pnID, psDST_CODE, pnLOC_ID_COUNTRY, pnLOC_ID_ASYLUM, pnLOC_ID_ORIGIN, pnLOC_ID_SOURCE,
        pnDIM_ID1, pnDIM_ID2, pnDIM_ID3, pnDIM_ID4, pnDIM_ID5,
        psLANG_CODE, psSUB_SEGMENT_NAME, pnPPG_ID);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_POPULATION_SEGMENT(pnID, pnVERSION_NBR, psLANG_CODE, psSUB_SEGMENT_NAME, pnPPG_ID);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_POPULATION_SEGMENT;
--
-- ----------------------------------------
-- DELETE_POPULATION_SEGMENT
-- ----------------------------------------
--
  procedure DELETE_POPULATION_SEGMENT
   (pnID in P_BASE.tmnPSG_ID,
    pnVERSION_NBR in P_BASE.tnPSG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSG_VERSION_NBR;
    xPSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_POPULATION_SEGMENT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSG_ROWID
    from T_POPULATION_SEGMENTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPULATION_SEGMENTS where rowid = xPSG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 1, 'Population segment has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_POPULATION_SEGMENT;
--
-- ----------------------------------------
-- SET_PSG_TEXT
-- ----------------------------------------
--
  procedure SET_PSG_TEXT
   (pnID in P_BASE.tmnPSG_ID,
    pnVERSION_NBR in out P_BASE.tnPSG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE,
    psText in P_BASE.tsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSG_VERSION_NBR;
    xPSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PSG_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSG_ROWID
    from T_POPULATION_SEGMENTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PSG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPULATION_SEGMENTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 1, 'Population segment has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PSG_TEXT;
--
-- ----------------------------------------
-- REMOVE_PSG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PSG_TEXT
   (pnID in P_BASE.tmnPSG_ID,
    pnVERSION_NBR in out P_BASE.tnPSG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSG_VERSION_NBR;
    xPSG_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PSG_TEXT',
      to_char(pnID) || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSG_ROWID
    from T_POPULATION_SEGMENTS
    where ID = pnID
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPULATION_SEGMENTS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 1, 'Population segment has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PSG_TEXT;
--
-- ----------------------------------------
-- INSERT_POPSEG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure INSERT_POPSEG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPSGAT_CODE,
    psDATA_TYPE in P_BASE.tmsPSGAT_DATA_TYPE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnPSGAT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tsPSGAT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_POPSEG_ATTRIBUTE_TYPE',
      psCODE || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'PSGAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_POPSEG_ATTRIBUTE_TYPES (CODE, DATA_TYPE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, psDATA_TYPE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_POPSEG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- UPDATE_POPSEG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure UPDATE_POPSEG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsPSGAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPSGAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPSGAT_ACTIVE_FLAG := null)
  is
    sDATA_TYPE P_BASE.tsPSGAT_DATA_TYPE;
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGAT_VERSION_NBR;
    xPSGAT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_POPSEG_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select DATA_TYPE, ITM_ID, VERSION_NBR, rowid
    into sDATA_TYPE, nITM_ID, nVERSION_NBR, xPSGAT_ROWID
    from T_POPSEG_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
    --
    -- Check if data type is to be changed and population segment attributes of this type already
    --  exist.
    --
      if psDATA_TYPE != sDATA_TYPE
      then
        declare
          sDummy varchar2(1);
        begin
          select 'x' into sDummy from T_POPSEG_ATTRIBUTES where PSGAT_CODE = psCODE;
        --
          raise TOO_MANY_ROWS;
        exception
          when NO_DATA_FOUND then null;
        --
          when TOO_MANY_ROWS
          then P_MESSAGE.DISPLAY_MESSAGE('PSG', 5, 'Cannot update data type of population segment attribute type already in use');
        end;
      end if;
    --
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'PSGAT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_POPSEG_ATTRIBUTE_TYPES
      set DATA_TYPE = nvl(psDATA_TYPE, DATA_TYPE),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSGAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 2, 'Population segment attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_POPSEG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_POPSEG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure SET_POPSEG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGAT_VERSION_NBR,
    psDATA_TYPE in P_BASE.tsPSGAT_DATA_TYPE := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnPSGAT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsPSGAT_ACTIVE_FLAG := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPSEG_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDATA_TYPE || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_POPSEG_ATTRIBUTE_TYPE
       (psCODE, psDATA_TYPE, psLANG_CODE, psDescription,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end, nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_POPSEG_ATTRIBUTE_TYPE
       (psCODE, pnVERSION_NBR, psDATA_TYPE, psLANG_CODE, psDescription,
        pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_POPSEG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- DELETE_POPSEG_ATTRIBUTE_TYPE
-- ----------------------------------------
--
  procedure DELETE_POPSEG_ATTRIBUTE_TYPE
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in P_BASE.tnPSGAT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGAT_VERSION_NBR;
    xPSGAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_POPSEG_ATTRIBUTE_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSGAT_ROWID
    from T_POPSEG_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPSEG_ATTRIBUTE_TYPES where rowid = xPSGAT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 2, 'Population segment attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_POPSEG_ATTRIBUTE_TYPE;
--
-- ----------------------------------------
-- SET_PSGAT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_PSGAT_DESCRIPTION
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PSGAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_PSGAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PSGAT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_PSGAT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_PSGAT_DESCRIPTION
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGAT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PSGAT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_PSGAT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PSGAT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_PSGAT_TEXT
-- ----------------------------------------
--
  procedure SET_PSGAT_TEXT
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGAT_VERSION_NBR;
    xPSGAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PSGAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSGAT_ROWID
    from T_POPSEG_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PSGAT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPSEG_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSGAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 2, 'Population segment attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PSGAT_TEXT;
--
-- ----------------------------------------
-- REMOVE_PSGAT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PSGAT_TEXT
   (psCODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGAT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGAT_VERSION_NBR;
    xPSGAT_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PSGAT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' ||
        to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSGAT_ROWID
    from T_POPSEG_ATTRIBUTE_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPSEG_ATTRIBUTE_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSGAT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 2, 'Population segment attribute type has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PSGAT_TEXT;
--
-- ----------------------------------------
-- INSERT_POPSEG_ATTRIBUTE
-- ----------------------------------------
--
  procedure INSERT_POPSEG_ATTRIBUTE
   (pnPSG_ID in P_BASE.tmnPSG_ID,
    psPSGAT_CODE in P_BASE.tmsPSGAT_CODE,
    psCHAR_VALUE in P_BASE.tsPSGA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnPSGA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdPSGA_DATE_VALUE := null)
  is
    sDATA_TYPE P_BASE.tsPSGAT_DATA_TYPE;
    sACTIVE_FLAG P_BASE.tsPSGAT_ACTIVE_FLAG;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.INSERT_POPSEG_ATTRIBUTE',
      to_char(pnPSG_ID) || '~' || psPSGAT_CODE || '~' || psCHAR_VALUE || '~' ||
        to_char(pnNUM_VALUE) || '~' || to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select DATA_TYPE, ACTIVE_FLAG
    into sDATA_TYPE, sACTIVE_FLAG
    from T_POPSEG_ATTRIBUTE_TYPES
    where CODE = psPSGAT_CODE;
  --
    if sACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('PSG', 6, 'Inactive population segment attribute type');
    end if;
  --
    case
      when sDATA_TYPE = 'C' and psCHAR_VALUE is not null then null;
      when sDATA_TYPE = 'N' and pnNUM_VALUE is not null then null;
      when sDATA_TYPE = 'D' and pdDATE_VALUE is not null then null;
      else P_MESSAGE.DISPLAY_MESSAGE('PSG', 7, 'Attribute of the correct type must be specified');
    end case;
  --
    insert into T_POPSEG_ATTRIBUTES (PSG_ID, PSGAT_CODE, CHAR_VALUE, NUM_VALUE, DATE_VALUE)
    values (pnPSG_ID, psPSGAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end INSERT_POPSEG_ATTRIBUTE;
--
-- ----------------------------------------
-- UPDATE_POPSEG_ATTRIBUTE
-- ----------------------------------------
--
  procedure UPDATE_POPSEG_ATTRIBUTE
   (pnPSG_ID in P_BASE.tmnPSG_ID,
    psPSGAT_CODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsPSGA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnPSGA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdPSGA_DATE_VALUE := null)
  is
    sCHAR_VALUE P_BASE.tsPSGA_CHAR_VALUE;
    nVERSION_NBR P_BASE.tnPSGA_VERSION_NBR;
    xPSGA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.UPDATE_POPSEG_ATTRIBUTE',
      to_char(pnPSG_ID) || '~' || psPSGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    select CHAR_VALUE, VERSION_NBR, rowid
    into sCHAR_VALUE, nVERSION_NBR, xPSGA_ROWID
    from T_POPSEG_ATTRIBUTES
    where PSG_ID = pnPSG_ID
    and PSGAT_CODE = psPSGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      update T_POPSEG_ATTRIBUTES
      set CHAR_VALUE = psCHAR_VALUE,
        NUM_VALUE = pnNUM_VALUE,
        DATE_VALUE = pdDATE_VALUE,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSGA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 3, 'Population segment attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end UPDATE_POPSEG_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_POPSEG_ATTRIBUTE
-- ----------------------------------------
--
  procedure SET_POPSEG_ATTRIBUTE
   (pnPSG_ID in P_BASE.tmnPSG_ID,
    psPSGAT_CODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGA_VERSION_NBR,
    psCHAR_VALUE in P_BASE.tsPSGA_CHAR_VALUE := null,
    pnNUM_VALUE in P_BASE.tnPSGA_NUM_VALUE := null,
    pdDATE_VALUE in P_BASE.tdPSGA_DATE_VALUE := null)
  is
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_POPSEG_ATTRIBUTE',
      to_char(pnPSG_ID) || '~' || psPSGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psCHAR_VALUE || '~' || to_char(pnNUM_VALUE) || '~' ||
        to_char(pdDATE_VALUE, 'YYYY-MM-DD HH24:MI:SS'));
  --
    if pnVERSION_NBR is null
    then
      INSERT_POPSEG_ATTRIBUTE
       (pnPSG_ID, psPSGAT_CODE, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_POPSEG_ATTRIBUTE
       (pnPSG_ID, psPSGAT_CODE, pnVERSION_NBR, psCHAR_VALUE, pnNUM_VALUE, pdDATE_VALUE);
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_POPSEG_ATTRIBUTE;
--
-- ----------------------------------------
-- DELETE_POPSEG_ATTRIBUTE
-- ----------------------------------------
--
  procedure DELETE_POPSEG_ATTRIBUTE
   (pnPSG_ID in P_BASE.tmnPSG_ID,
    psPSGAT_CODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in P_BASE.tnPSGA_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGA_VERSION_NBR;
    xPSGA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_POPSEG_ATTRIBUTE',
      to_char(pnPSG_ID) || '~' || psPSGAT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSGA_ROWID
    from T_POPSEG_ATTRIBUTES
    where PSG_ID = pnPSG_ID
    and PSGAT_CODE = psPSGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_POPSEG_ATTRIBUTES where rowid = xPSGA_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 3, 'Population segment attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_POPSEG_ATTRIBUTE;
--
-- ----------------------------------------
-- SET_PSGA_TEXT
-- ----------------------------------------
--
  procedure SET_PSGA_TEXT
   (pnPSG_ID in P_BASE.tmnPSG_ID,
    psPSGAT_CODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGA_VERSION_NBR;
    xPSGA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_PSGA_TEXT',
      to_char(pnPSG_ID) || '~' || psPSGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSGA_ROWID
    from T_POPSEG_ATTRIBUTES
    where PSG_ID = pnPSG_ID
    and PSGAT_CODE = psPSGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'PSGA', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_POPSEG_ATTRIBUTES
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSGA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 3, 'Population segment attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_PSGA_TEXT;
--
-- ----------------------------------------
-- REMOVE_PSGA_TEXT
-- ----------------------------------------
--
  procedure REMOVE_PSGA_TEXT
   (pnPSG_ID in P_BASE.tmnPSG_ID,
    psPSGAT_CODE in P_BASE.tmsPSGAT_CODE,
    pnVERSION_NBR in out P_BASE.tnPSGA_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnPSGA_VERSION_NBR;
    xPSGA_ROWID rowid;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.REMOVE_PSGA_TEXT',
      to_char(pnPSG_ID) || '~' || psPSGAT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xPSGA_ROWID
    from T_POPSEG_ATTRIBUTES
    where PSG_ID = pnPSG_ID
    and PSGAT_CODE = psPSGAT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_POPSEG_ATTRIBUTES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xPSGA_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE('PSG', 3, 'Population segment attribute has been updated by another user');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end REMOVE_PSGA_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'PSG'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_POPULATION_SEGMENT;
/

show errors
