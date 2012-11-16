create or replace package body P_STATISTIC_TYPE is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    psDST_ID_FLAG in P_BASE.tmsFlag,
    psLOC_ID_ASYLUM_COUNTRY_FLAG in P_BASE.tmsFlag,
    psLOC_ID_ASYLUM_FLAG in P_BASE.tmsFlag,
    psLOC_ID_ORIGIN_COUNTRY_FLAG in P_BASE.tmsFlag,
    psLOC_ID_ORIGIN_FLAG in P_BASE.tmsFlag,
    psDIM_ID1_FLAG in P_BASE.tmsFlag,
    psDIMT_CODE1 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID2_FLAG in P_BASE.tmsFlag,
    psDIMT_CODE2 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID3_FLAG in P_BASE.tmsFlag,
    psDIMT_CODE3 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID4_FLAG in P_BASE.tmsFlag,
    psDIMT_CODE4 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID5_FLAG in P_BASE.tmsFlag,
    psDIMT_CODE5 in P_BASE.tsDIMT_CODE := null,
    psSEX_CODE_FLAG in P_BASE.tmsFlag,
    psAGR_ID_FLAG in P_BASE.tmsFlag,
    psPGR_ID_SUBGROUP_FLAG in P_BASE.tmsFlag,
    pnDISPLAY_SEQ in P_BASE.tnSTCT_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsSTCT_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_STATISTIC_TYPE',
      psCODE || '~' || psDST_ID_FLAG || '~' ||
        psLOC_ID_ASYLUM_COUNTRY_FLAG || '~' || psLOC_ID_ASYLUM_FLAG || '~' ||
        psLOC_ID_ORIGIN_COUNTRY_FLAG || '~' || psLOC_ID_ORIGIN_FLAG || '~' ||
        psDIM_ID1_FLAG || '~' || psDIMT_CODE1 || '~' ||
        psDIM_ID2_FLAG || '~' || psDIMT_CODE2 || '~' ||
        psDIM_ID3_FLAG || '~' || psDIMT_CODE3 || '~' ||
        psDIM_ID4_FLAG || '~' || psDIMT_CODE4 || '~' ||
        psDIM_ID5_FLAG || '~' || psDIMT_CODE5 || '~' ||
        psSEX_CODE_FLAG || '~' || psAGR_ID_FLAG || '~' || psPGR_ID_SUBGROUP_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'STCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_STATISTIC_TYPES
     (CODE, DST_ID_FLAG,
      LOC_ID_ASYLUM_COUNTRY_FLAG, LOC_ID_ASYLUM_FLAG,
      LOC_ID_ORIGIN_COUNTRY_FLAG, LOC_ID_ORIGIN_FLAG,
      DIM_ID1_FLAG, DIMT_CODE1, DIM_ID2_FLAG, DIMT_CODE2, DIM_ID3_FLAG, DIMT_CODE3,
      DIM_ID4_FLAG, DIMT_CODE4, DIM_ID5_FLAG, DIMT_CODE5, SEX_CODE_FLAG, AGR_ID_FLAG,
      PGR_ID_SUBGROUP_FLAG, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values
     (psCODE, psDST_ID_FLAG,
      psLOC_ID_ASYLUM_COUNTRY_FLAG, psLOC_ID_ASYLUM_FLAG,
      psLOC_ID_ORIGIN_COUNTRY_FLAG, psLOC_ID_ORIGIN_FLAG,
      psDIM_ID1_FLAG, psDIMT_CODE1, psDIM_ID2_FLAG, psDIMT_CODE2, psDIM_ID3_FLAG, psDIMT_CODE3,
      psDIM_ID4_FLAG, psDIMT_CODE4, psDIM_ID5_FLAG, psDIMT_CODE5, psSEX_CODE_FLAG, psAGR_ID_FLAG,
      psPGR_ID_SUBGROUP_FLAG, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STATISTIC_TYPE;
--
-- ----------------------------------------
-- UPDATE_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure UPDATE_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psDST_ID_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ASYLUM_COUNTRY_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ASYLUM_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ORIGIN_COUNTRY_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ORIGIN_FLAG in P_BASE.tsFlag := null,
    psDIM_ID1_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE1 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID2_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE2 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID3_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE3 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID4_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE4 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID5_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE5 in P_BASE.tsDIMT_CODE := null,
    psSEX_CODE_FLAG in P_BASE.tsFlag := null,
    psAGR_ID_FLAG in P_BASE.tsFlag := null,
    psPGR_ID_SUBGROUP_FLAG in P_BASE.tsFlag := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCT_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDST_ID_FLAG || '~' ||
        psLOC_ID_ASYLUM_COUNTRY_FLAG || '~' || psLOC_ID_ASYLUM_FLAG || '~' ||
        psLOC_ID_ORIGIN_COUNTRY_FLAG || '~' || psLOC_ID_ORIGIN_FLAG || '~' ||
        psDIM_ID1_FLAG || '~' || psDIMT_CODE1 || '~' ||
        psDIM_ID2_FLAG || '~' || psDIMT_CODE2 || '~' ||
        psDIM_ID3_FLAG || '~' || psDIMT_CODE3 || '~' ||
        psDIM_ID4_FLAG || '~' || psDIMT_CODE4 || '~' ||
        psDIM_ID5_FLAG || '~' || psDIMT_CODE5 || '~' ||
        psSEX_CODE_FLAG || '~' || psAGR_ID_FLAG || '~' || psPGR_ID_SUBGROUP_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCT_ROWID
    from T_STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'STCT', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_STATISTIC_TYPES
      set DST_ID_FLAG = nvl(psDST_ID_FLAG, DST_ID_FLAG),
        LOC_ID_ASYLUM_COUNTRY_FLAG = nvl(psLOC_ID_ASYLUM_COUNTRY_FLAG, LOC_ID_ASYLUM_COUNTRY_FLAG),
        LOC_ID_ASYLUM_FLAG = nvl(psLOC_ID_ASYLUM_FLAG, LOC_ID_ASYLUM_FLAG),
        LOC_ID_ORIGIN_COUNTRY_FLAG = nvl(psLOC_ID_ORIGIN_COUNTRY_FLAG, LOC_ID_ORIGIN_COUNTRY_FLAG),
        LOC_ID_ORIGIN_FLAG = nvl(psLOC_ID_ORIGIN_FLAG, LOC_ID_ORIGIN_FLAG),
        DIM_ID1_FLAG = nvl(psDIM_ID1_FLAG, DIM_ID1_FLAG),
        DIMT_CODE1 =
          case when psDIM_ID1_FLAG = 'N' then psDIMT_CODE1 else nvl(psDIMT_CODE1, DIMT_CODE1) end,
        DIM_ID2_FLAG = nvl(psDIM_ID2_FLAG, DIM_ID2_FLAG),
        DIMT_CODE2 =
          case when psDIM_ID2_FLAG = 'N' then psDIMT_CODE2 else nvl(psDIMT_CODE2, DIMT_CODE2) end,
        DIM_ID3_FLAG = nvl(psDIM_ID3_FLAG, DIM_ID3_FLAG),
        DIMT_CODE3 =
          case when psDIM_ID3_FLAG = 'N' then psDIMT_CODE3 else nvl(psDIMT_CODE3, DIMT_CODE3) end,
        DIM_ID4_FLAG = nvl(psDIM_ID4_FLAG, DIM_ID4_FLAG),
        DIMT_CODE4 =
          case when psDIM_ID4_FLAG = 'N' then psDIMT_CODE4 else nvl(psDIMT_CODE4, DIMT_CODE4) end,
        DIM_ID5_FLAG = nvl(psDIM_ID5_FLAG, DIM_ID5_FLAG),
        DIMT_CODE5 =
          case when psDIM_ID5_FLAG = 'N' then psDIMT_CODE5 else nvl(psDIMT_CODE5, DIMT_CODE5) end,
        SEX_CODE_FLAG = nvl(psSEX_CODE_FLAG, SEX_CODE_FLAG),
        AGR_ID_FLAG = nvl(psAGR_ID_FLAG, AGR_ID_FLAG),
        PGR_ID_SUBGROUP_FLAG = nvl(psPGR_ID_SUBGROUP_FLAG, PGR_ID_SUBGROUP_FLAG),
        DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_STATISTIC_TYPE;
--
-- ----------------------------------------
-- SET_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure SET_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    psDST_ID_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ASYLUM_COUNTRY_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ASYLUM_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ORIGIN_COUNTRY_FLAG in P_BASE.tsFlag := null,
    psLOC_ID_ORIGIN_FLAG in P_BASE.tsFlag := null,
    psDIM_ID1_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE1 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID2_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE2 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID3_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE3 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID4_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE4 in P_BASE.tsDIMT_CODE := null,
    psDIM_ID5_FLAG in P_BASE.tsFlag := null,
    psDIMT_CODE5 in P_BASE.tsDIMT_CODE := null,
    psSEX_CODE_FLAG in P_BASE.tsFlag := null,
    psAGR_ID_FLAG in P_BASE.tsFlag := null,
    psPGR_ID_SUBGROUP_FLAG in P_BASE.tsFlag := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCT_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCT_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psDST_ID_FLAG || '~' ||
        psLOC_ID_ASYLUM_COUNTRY_FLAG || '~' || psLOC_ID_ASYLUM_FLAG || '~' ||
        psLOC_ID_ORIGIN_COUNTRY_FLAG || '~' || psLOC_ID_ORIGIN_FLAG || '~' ||
        psDIM_ID1_FLAG || '~' || psDIMT_CODE1 || '~' ||
        psDIM_ID2_FLAG || '~' || psDIMT_CODE2 || '~' ||
        psDIM_ID3_FLAG || '~' || psDIMT_CODE3 || '~' ||
        psDIM_ID4_FLAG || '~' || psDIMT_CODE4 || '~' ||
        psDIM_ID5_FLAG || '~' || psDIMT_CODE5 || '~' ||
        psSEX_CODE_FLAG || '~' || psAGR_ID_FLAG || '~' || psPGR_ID_SUBGROUP_FLAG || '~' ||
        to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_STATISTIC_TYPE
       (psCODE, psLANG_CODE, psDescription, psDST_ID_FLAG,
        psLOC_ID_ASYLUM_COUNTRY_FLAG, psLOC_ID_ASYLUM_FLAG,
        psLOC_ID_ORIGIN_COUNTRY_FLAG, psLOC_ID_ORIGIN_FLAG,
        psDIM_ID1_FLAG, psDIMT_CODE1, psDIM_ID2_FLAG, psDIMT_CODE2, psDIM_ID3_FLAG, psDIMT_CODE3,
        psDIM_ID4_FLAG, psDIMT_CODE4, psDIM_ID5_FLAG, psDIMT_CODE5,
        psSEX_CODE_FLAG, psAGR_ID_FLAG, psPGR_ID_SUBGROUP_FLAG,
        case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
        nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STATISTIC_TYPE
       (psCODE, pnVERSION_NBR, psLANG_CODE, psDescription, psDST_ID_FLAG,
        psLOC_ID_ASYLUM_COUNTRY_FLAG, psLOC_ID_ASYLUM_FLAG,
        psLOC_ID_ORIGIN_COUNTRY_FLAG, psLOC_ID_ORIGIN_FLAG,
        psDIM_ID1_FLAG, psDIMT_CODE1, psDIM_ID2_FLAG, psDIMT_CODE2, psDIM_ID3_FLAG, psDIMT_CODE3,
        psDIM_ID4_FLAG, psDIMT_CODE4, psDIM_ID5_FLAG, psDIMT_CODE5,
        psSEX_CODE_FLAG, psAGR_ID_FLAG, psPGR_ID_SUBGROUP_FLAG, pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STATISTIC_TYPE;
--
-- ----------------------------------------
-- DELETE_STATISTIC_TYPE
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_TYPE
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in P_BASE.tnSTCT_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_STATISTIC_TYPE',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCT_ROWID
    from T_STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STATISTIC_TYPES where rowid = xSTCT_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STATISTIC_TYPE;
--
-- ----------------------------------------
-- SET_STCT_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_STCT_DESCRIPTION
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_STCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STCT_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_STCT_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_STCT_DESCRIPTION
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_STCT_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_STCT_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STCT_DESCRIPTION;
--
-- ----------------------------------------
-- SET_STCT_TEXT
-- ----------------------------------------
--
  procedure SET_STCT_TEXT
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCT_ROWID
    from T_STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STCT', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STATISTIC_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STCT_TEXT;
--
-- ----------------------------------------
-- REMOVE_STCT_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STCT_TEXT
   (psCODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCT_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
    xSTCT_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_STCT_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCT_ROWID
    from T_STATISTIC_TYPES
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_STATISTIC_TYPES
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCT_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'Statistic type has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STCT_TEXT;
--
-- ----------------------------------------
-- INSERT_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText,
    pnDISPLAY_SEQ in P_BASE.tnSTCG_DISPLAY_SEQ := null,
    psACTIVE_FLAG in P_BASE.tmsSTCG_ACTIVE_FLAG := 'Y')
  is
    nITM_ID P_BASE.tnITM_ID;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnDISPLAY_SEQ) || '~' || psACTIVE_FLAG || '~' ||
        psLANG_CODE || '~' || to_char(length(psDescription)) || ':' || psDescription);
  --
    P_TEXT.SET_TEXT(nITM_ID, 'STCG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    insert into T_STATISTIC_GROUPS (CODE, DISPLAY_SEQ, ACTIVE_FLAG, ITM_ID)
    values (psCODE, pnDISPLAY_SEQ, psACTIVE_FLAG, nITM_ID);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STATISTIC_GROUP;
--
-- ----------------------------------------
-- UPDATE_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure UPDATE_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCG_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCG_ACTIVE_FLAG := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) ||
        '~' || psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCG_ROWID
    from T_STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      if psDescription is not null
      then P_TEXT.SET_TEXT(nITM_ID, 'STCG', 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
      end if;
    --
      update T_STATISTIC_GROUPS
      set DISPLAY_SEQ = case when pnDISPLAY_SEQ = -1e6 then DISPLAY_SEQ else pnDISPLAY_SEQ end,
        ACTIVE_FLAG = nvl(psACTIVE_FLAG, ACTIVE_FLAG),
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- SET_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure SET_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tsLANG_CODE := null,
    psDescription in P_BASE.tsText := null,
    pnDISPLAY_SEQ in P_BASE.tnSTCG_DISPLAY_SEQ := -1e6,
    psACTIVE_FLAG in P_BASE.tsSTCG_ACTIVE_FLAG := null)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || to_char(pnDISPLAY_SEQ) || '~' ||
        psACTIVE_FLAG || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    if pnVERSION_NBR is null
    then
      INSERT_STATISTIC_GROUP(psCODE, psLANG_CODE, psDescription,
                             case when pnDISPLAY_SEQ = -1e6 then null else pnDISPLAY_SEQ end,
                             nvl(psACTIVE_FLAG, 'Y'));
    --
      pnVERSION_NBR := 1;
    else
      UPDATE_STATISTIC_GROUP(psCODE, pnVERSION_NBR, psLANG_CODE, psDescription,
                             pnDISPLAY_SEQ, psACTIVE_FLAG);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STATISTIC_GROUP;
--
-- ----------------------------------------
-- DELETE_STATISTIC_GROUP
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_GROUP
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in P_BASE.tnSTCG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_STATISTIC_GROUP',
      psCODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCG_ROWID
    from T_STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STATISTIC_GROUPS where rowid = xSTCG_ROWID;
    --
      P_TEXT.DELETE_TEXT(nITM_ID);
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STATISTIC_GROUP;
--
-- ----------------------------------------
-- SET_STCG_DESCRIPTION
-- ----------------------------------------
--
  procedure SET_STCG_DESCRIPTION
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psDescription in P_BASE.tmsText)
  is
    nSEQ_NBR P_BASE.tnTXT_SEQ_NBR := 1;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STCG_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psDescription)) || ':' || psDescription);
  --
    SET_STCG_TEXT(psCODE, pnVERSION_NBR, 'DESCR', nSEQ_NBR, psLANG_CODE, psDescription);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STCG_DESCRIPTION;
--
-- ----------------------------------------
-- REMOVE_STCG_DESCRIPTION
-- ----------------------------------------
--
  procedure REMOVE_STCG_DESCRIPTION
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_STCG_DESCRIPTION',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psLANG_CODE);
  --
    REMOVE_STCG_TEXT(psCODE, pnVERSION_NBR, 'DESCR', 1, psLANG_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STCG_DESCRIPTION;
--
-- ----------------------------------------
-- SET_STCG_TEXT
-- ----------------------------------------
--
  procedure SET_STCG_TEXT
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STCG_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCG_ROWID
    from T_STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STCG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STATISTIC_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STCG_TEXT;
--
-- ----------------------------------------
-- REMOVE_STCG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STCG_TEXT
   (psCODE in P_BASE.tmsSTCG_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
    xSTCG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_STCG_TEXT',
      psCODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCG_ROWID
    from T_STATISTIC_GROUPS
    where CODE = psCODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_STATISTIC_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'Statistic group has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STCG_TEXT;
--
-- ----------------------------------------
-- INSERT_STATISTIC_TYPE_GROUPING
-- ----------------------------------------
--
  procedure INSERT_STATISTIC_TYPE_GROUPING
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE)
  is
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_STATISTIC_TYPE_GROUPING',
      psSTCG_CODE || '~' || psSTCT_CODE);
  --
    insert into T_STATISTIC_TYPES_IN_GROUPS (STCG_CODE, STCT_CODE)
    values (psSTCG_CODE, psSTCT_CODE);
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_STATISTIC_TYPE_GROUPING;
--
-- ----------------------------------------
-- DELETE_STATISTIC_TYPE_GROUPING
-- ----------------------------------------
--
  procedure DELETE_STATISTIC_TYPE_GROUPING
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in P_BASE.tnSTCTG_VERSION_NBR)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
    xSTCTG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_STATISTIC_TYPE_GROUPING',
      psSTCG_CODE || '~' || psSTCT_CODE || '~' || to_char(pnVERSION_NBR));
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCTG_ROWID
    from T_STATISTIC_TYPES_IN_GROUPS
    where STCG_CODE = psSTCG_CODE
    and STCT_CODE = psSTCT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      delete from T_STATISTIC_TYPES_IN_GROUPS where rowid = xSTCTG_ROWID;
    --
      if nITM_ID is not null
      then P_TEXT.DELETE_TEXT(nITM_ID);
      end if;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic type grouping has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_STATISTIC_TYPE_GROUPING;
--
-- ----------------------------------------
-- SET_STCTG_TEXT
-- ----------------------------------------
--
  procedure SET_STCTG_TEXT
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCTG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXT_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psText in P_BASE.tmsText)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
    xSTCTG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.SET_STCTG_TEXT',
      psSTCG_CODE || '~' || psSTCT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
        to_char(length(psText)) || ':' || psText);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCTG_ROWID
    from T_STATISTIC_TYPES_IN_GROUPS
    where STCG_CODE = psSTCG_CODE
    and STCT_CODE = psSTCT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.SET_TEXT(nITM_ID, 'STCTG', psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psText);
    --
      update T_STATISTIC_TYPES_IN_GROUPS
      set ITM_ID = nITM_ID,
        VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic type grouping has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end SET_STCTG_TEXT;
--
-- ----------------------------------------
-- REMOVE_STCTG_TEXT
-- ----------------------------------------
--
  procedure REMOVE_STCTG_TEXT
   (psSTCG_CODE in P_BASE.tmsSTCG_CODE,
    psSTCT_CODE in P_BASE.tmsSTCT_CODE,
    pnVERSION_NBR in out P_BASE.tnSTCTG_VERSION_NBR,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in P_BASE.tnTXT_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    nITM_ID P_BASE.tnITM_ID;
    nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
    xSTCTG_ROWID rowid;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.REMOVE_STCTG_TEXT',
      psSTCG_CODE || '~' || psSTCT_CODE || '~' || to_char(pnVERSION_NBR) || '~' ||
        psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    select ITM_ID, VERSION_NBR, rowid
    into nITM_ID, nVERSION_NBR, xSTCTG_ROWID
    from T_STATISTIC_TYPES_IN_GROUPS
    where STCG_CODE = psSTCG_CODE
    and STCT_CODE = psSTCT_CODE
    for update;
  --
    if pnVERSION_NBR = nVERSION_NBR
    then
      P_TEXT.DELETE_TEXT(nITM_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE);
    --
      update T_STATISTIC_TYPES_IN_GROUPS
      set VERSION_NBR = VERSION_NBR + 1
      where rowid = xSTCTG_ROWID
      returning VERSION_NBR into pnVERSION_NBR;
    else
      P_MESSAGE.DISPLAY_MESSAGE(sComponent, 3, 'Statistic type grouping has been updated by another user');
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end REMOVE_STCTG_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != $$PLSQL_UNIT
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
  if sComponent != 'STCT'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_STATISTIC_TYPE;
/

show errors
