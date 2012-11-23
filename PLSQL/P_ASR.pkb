create or replace package body P_ASR is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_TABLE7AB
-- ----------------------------------------
--
  procedure INSERT_TABLE7AB
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID,
    psSOURCE in P_BASE.tsPGRA_CHAR_VALUE,
    psBASIS in P_BASE.tsPGRA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE)
  is
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR+1) || '-01-01', 'YYYY-MM-DD');
    nPGR_ID P_BASE.tnPGR_ID;
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.INSERT_TABLE7AB',
      to_char(pnASR_YEAR)  || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnDST_ID) || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE) || '~' ||
        psSOURCE || '~' || psBASIS);
  --
  -- Check that at lease one statistic value has been provided for this row.
  --
    if nvl(pnREFRTN_VALUE, 0) = 0 and nvl(pnREFRTN_AH_VALUE, 0) = 0
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'At least one statistic value must be supplied');
    end if;
  --
  -- Check that UNHCR-assisted value is not greater than total value.
  --
    if pnREFRTN_AH_VALUE > pnREFRTN_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Create new population group representing this table 7A/B row.
  --
    P_POPULATION_GROUP.INSERT_POPULATION_GROUP
     (nPGR_ID, dSTART_DATE, dEND_DATE,
      pnDST_ID => pnDST_ID,
      pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
      pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY);
  --
  -- Create population group attributes for the source and basis.
  --
    if psSOURCE is not null
    then P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE(nPGR_ID, 'SOURCE', psSOURCE);
    end if;
  --
    if psBASIS is not null
    then P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE(nPGR_ID, 'BASIS', psBASIS);
    end if;
  --
  -- Create statistics for the REFRTN and REFRTN_AH statistic types.
  --
    if nvl(pnREFRTN_VALUE, 0) != 0
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnPGR_ID_PRIMARY => nPGR_ID,
        pnVALUE => pnREFRTN_VALUE);
    end if;
  --
    if nvl(pnREFRTN_AH_VALUE, 0) != 0
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN_AH', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnPGR_ID_PRIMARY => nPGR_ID,
        pnVALUE => pnREFRTN_AH_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end INSERT_TABLE7AB;
--
-- ----------------------------------------
-- UPDATE_TABLE7AB
-- ----------------------------------------
--
  procedure UPDATE_TABLE7AB
   (pnASR_YEAR in P_BASE.tmnYear,
    pnLOC_ID_ORIGIN_COUNTRY in P_BASE.tmnLOC_ID,
    pnDST_ID in P_BASE.tmnDST_ID,
    pnLOC_ID_ASYLUM_COUNTRY in P_BASE.tmnLOC_ID,
    psSOURCE in P_BASE.tsPGRA_CHAR_VALUE,
    psBASIS in P_BASE.tsPGRA_CHAR_VALUE,
    pnREFRTN_VALUE in P_BASE.tnSTC_VALUE,
    pnREFRTN_AH_VALUE in P_BASE.tnSTC_VALUE,
    pnPGR_ID_PRIMARY in P_BASE.tmnPGR_ID,
    pnPGR_VERSION_NBR in P_BASE.tnPGR_VERSION_NBR,
    pnPGRA_VERSION_NBR_SOURCE in P_BASE.tnPGRA_VERSION_NBR,
    pnPGRA_VERSION_NBR_BASIS in P_BASE.tnPGRA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nPGRA_VERSION_NBR_SOURCE P_BASE.tnPGRA_VERSION_NBR := pnPGRA_VERSION_NBR_SOURCE;
    nPGRA_VERSION_NBR_BASIS P_BASE.tnPGRA_VERSION_NBR := pnPGRA_VERSION_NBR_BASIS;
    nREFRTN_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    nREFRTN_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
    dSTART_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR) || '-01-01', 'YYYY-MM-DD');
    dEND_DATE P_BASE.tdDate := to_date(to_char(pnASR_YEAR+1) || '-01-01', 'YYYY-MM-DD');
    nSTC_ID P_BASE.tnSTC_ID;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.UPDATE_TABLE7AB',
      to_char(pnASR_YEAR) || '~' || to_char(pnLOC_ID_ORIGIN_COUNTRY) || '~' ||
        to_char(pnDST_ID) || '~' || to_char(pnLOC_ID_ASYLUM_COUNTRY) || '~' ||
        psSOURCE || '~' || psBASIS || '~' ||
        to_char(pnREFRTN_VALUE) || '~' || to_char(pnREFRTN_AH_VALUE) || '~' ||
        to_char(pnPGR_ID_PRIMARY)  || '~' ||
        to_char(pnPGRA_VERSION_NBR_SOURCE) || '~' || to_char(pnPGRA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnREFRTN_STC_ID) || '~' || to_char(pnREFRTN_VERSION_NBR) || '~' ||
        to_char(pnREFRTN_AH_STC_ID) || '~' || to_char(pnREFRTN_AH_VERSION_NBR));
  --
  -- Check that at lease one statistic value has been provided for this row.
  --
    if nvl(pnREFRTN_VALUE, 0) = 0 and nvl(pnREFRTN_AH_VALUE, 0) = 0
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 1, 'At least one statistic value must be supplied');
    end if;
  --
  -- Check that UNHCR-assisted value is not greater than total value.
  --
    if pnREFRTN_AH_VALUE > pnREFRTN_VALUE
    then P_MESSAGE.DISPLAY_MESSAGE(sComponent, 2, 'UNHCR-assisted value may not be greater than total value');
    end if;
  --
  -- Update or insert population group attributes for the source and basis. Delete attributes where
  --  the new value is null.
  --
    if psSOURCE is null and pnPGRA_VERSION_NBR_SOURCE is not null
    then
      P_POPULATION_GROUP.DELETE_PGR_ATTRIBUTE(pnPGR_ID_PRIMARY, 'SOURCE', nPGRA_VERSION_NBR_SOURCE);
    elsif psSOURCE is not null and pnPGRA_VERSION_NBR_SOURCE is null
    then
      P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE(pnPGR_ID_PRIMARY, 'SOURCE', psSOURCE);
    else
      P_POPULATION_GROUP.UPDATE_PGR_ATTRIBUTE
       (pnPGR_ID_PRIMARY, 'SOURCE', nPGRA_VERSION_NBR_SOURCE, psSOURCE);
    end if;
  --
    if psBASIS is null and pnPGRA_VERSION_NBR_BASIS is not null
    then
      P_POPULATION_GROUP.DELETE_PGR_ATTRIBUTE(pnPGR_ID_PRIMARY, 'BASIS', nPGRA_VERSION_NBR_BASIS);
    elsif psBASIS is not null and pnPGRA_VERSION_NBR_BASIS is null
    then
      P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE(pnPGR_ID_PRIMARY, 'BASIS', psBASIS);
    else
      P_POPULATION_GROUP.UPDATE_PGR_ATTRIBUTE
       (pnPGR_ID_PRIMARY, 'BASIS', nPGRA_VERSION_NBR_BASIS, psBASIS);
    end if;
  --
  -- Update or insert statistics for the REFRTN and REFRTN_AH statistic types. Delete statistics
  --  where the new value is null or zero.
  -- 
    if nvl(pnREFRTN_VALUE, 0) = 0 and pnREFRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_STC_ID, pnREFRTN_VERSION_NBR);
    elsif nvl(pnREFRTN_VALUE, 0) != 0 and pnREFRTN_STC_ID is null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnPGR_ID_PRIMARY => pnPGR_ID_PRIMARY,
        pnVALUE => pnREFRTN_VALUE);
    else
      P_STATISTIC.UPDATE_STATISTIC(pnREFRTN_STC_ID, nREFRTN_VERSION_NBR, pnREFRTN_VALUE);
    end if;
  --
    if nvl(pnREFRTN_AH_VALUE, 0) = 0 and pnREFRTN_AH_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_AH_STC_ID, pnREFRTN_AH_VERSION_NBR);
    elsif nvl(pnREFRTN_AH_VALUE, 0) != 0 and pnREFRTN_AH_STC_ID is null
    then
      P_STATISTIC.INSERT_STATISTIC
       (nSTC_ID, 'REFRTN_AH', dSTART_DATE, dEND_DATE,
        pnDST_ID => pnDST_ID,
        pnLOC_ID_ASYLUM_COUNTRY => pnLOC_ID_ASYLUM_COUNTRY,
        pnLOC_ID_ORIGIN_COUNTRY => pnLOC_ID_ORIGIN_COUNTRY,
        pnPGR_ID_PRIMARY => pnPGR_ID_PRIMARY,
        pnVALUE => pnREFRTN_AH_VALUE);
    else
      P_STATISTIC.UPDATE_STATISTIC(pnREFRTN_AH_STC_ID, nREFRTN_AH_VERSION_NBR, pnREFRTN_AH_VALUE);
    end if;
  --
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end UPDATE_TABLE7AB;
--
-- ----------------------------------------
-- DELETE_TABLE7AB
-- ----------------------------------------
--
  procedure DELETE_TABLE7AB
   (pnPGR_ID_PRIMARY in P_BASE.tnPGR_ID,
    pnPGR_VERSION_NBR in P_BASE.tnPGR_VERSION_NBR,
    pnPGRA_VERSION_NBR_SOURCE in P_BASE.tnPGRA_VERSION_NBR,
    pnPGRA_VERSION_NBR_BASIS in P_BASE.tnPGRA_VERSION_NBR,
    pnREFRTN_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR,
    pnREFRTN_AH_STC_ID in P_BASE.tnSTC_ID,
    pnREFRTN_AH_VERSION_NBR in P_BASE.tnSTC_VERSION_NBR)
  is
    nPGR_VERSION_NBR P_BASE.tnPGR_VERSION_NBR := pnPGR_VERSION_NBR;
    nPGRA_VERSION_NBR_SOURCE P_BASE.tnPGRA_VERSION_NBR := pnPGRA_VERSION_NBR_SOURCE;
    nPGRA_VERSION_NBR_BASIS P_BASE.tnPGRA_VERSION_NBR := pnPGRA_VERSION_NBR_BASIS;
    nREFRTN_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_VERSION_NBR;
    nREFRTN_AH_VERSION_NBR P_BASE.tnSTC_VERSION_NBR := pnREFRTN_AH_VERSION_NBR;
  begin
    P_UTILITY.START_MODULE
     (sVersion || '-' || sModule || '.DELETE_TABLE7AB',
      to_char(pnPGR_ID_PRIMARY)  || '~' || to_char(pnPGR_VERSION_NBR) || '~' ||
        to_char(pnPGRA_VERSION_NBR_SOURCE) || '~' || to_char(pnPGRA_VERSION_NBR_BASIS) || '~' ||
        to_char(pnREFRTN_STC_ID) || '~' || to_char(pnREFRTN_VERSION_NBR) || '~' ||
        to_char(pnREFRTN_AH_STC_ID) || '~' || to_char(pnREFRTN_AH_VERSION_NBR));
  --
  -- Delete the REFRTN and REFRTN_AH statistics.
  --
    if pnREFRTN_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_STC_ID, nREFRTN_VERSION_NBR);
    end if;
  --
    if pnREFRTN_AH_STC_ID is not null
    then P_STATISTIC.DELETE_STATISTIC(pnREFRTN_AH_STC_ID, nREFRTN_AH_VERSION_NBR);
    end if;
/*--
  -- Delete the source and basis population group attributes and the primary population group.
  --
    if pnPGR_ID_PRIMARY is not null
    then
      if nPGRA_VERSION_NBR_SOURCE is not null
      then
        P_POPULATION_GROUP.DELETE_PGR_ATTRIBUTE(pnPGR_ID_PRIMARY, 'SOURCE', nPGRA_VERSION_NBR_SOURCE);
      end if;
    --
      if nPGRA_VERSION_NBR_BASIS is not null
      then
        P_POPULATION_GROUP.DELETE_PGR_ATTRIBUTE(pnPGR_ID_PRIMARY, 'BASIS', nPGRA_VERSION_NBR_BASIS);
      end if;
    --
      P_POPULATION_GROUP.DELETE_POPULATION_GROUP(pnPGR_ID_PRIMARY, nPGR_VERSION_NBR);
    end if;
*/--
    P_UTILITY.END_MODULE;
  exception
    when others
    then P_UTILITY.TRACE_EXCEPTION;
  end DELETE_TABLE7AB;
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
  if sComponent != 'ASR'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 3, 'Component code mismatch');
  end if;
--
end P_ASR;
/

show errors