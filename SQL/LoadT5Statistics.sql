set serveroutput on

declare
  nID P_BASE.tnSTC_ID;
  iCount pls_integer := 0;
begin
  for rSTC in
   (select PER1.ID as PER_ID_START, PER2.ID as PER_ID_END, PER3.ID as PER_ID_YEAR,
      COU.ID as LOC_ID_COUNTRY, OGN.ID as LOC_ID_ORIGIN,
      DIM1.ID as DIM_ID1, DIM2.ID as DIM_ID2,
      STC.ASY_START, STC.ASY_AH_START,
      STC.ASYAPP, STC.ASYREC_CV, STC.ASYREC_CP, STC.ASYREJ, STC.ASYOTHCL, STC.TOTAL_DECISIONS,
      STC.ASY_END, STC.ASY_AH_END,
      STC.STATSYEAR, STC.COU_CODE_ASYLUM, STC.COU_CODE_ORIGIN, STC.DIM_RSDTYPE_VALUE, STC.DIM_RSDLEVEL_VALUE,
      row_number() over (partition by STC.STATSYEAR, COU.ID, OGN.ID, DIM1.ID, DIM2.ID order by 1) as DUPLICATE_NUMBER
    from STAGE.S_ASR_T5 STC
    join TIME_PERIODS PER1
      on PER1.START_DATE = trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY')
      and PER1.PERT_CODE = 'DAY'
    join TIME_PERIODS PER2
      on PER2.START_DATE = add_months(trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY'), 12) - 1
      and PER2.PERT_CODE = 'DAY'
    join TIME_PERIODS PER3
      on PER3.START_DATE = trunc(to_date(STC.STATSYEAR, 'YYYY'), 'YYYY')
      and PER3.PERT_CODE = 'YEAR'
    left outer join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = upper(STC.COU_CODE_ASYLUM)
      and COU.START_DATE <= PER2.START_DATE
      and COU.END_DATE > PER2.START_DATE
    left outer join ORIGINS OGN
      on OGN.UNHCR_COUNTRY_CODE = upper(STC.COU_CODE_ORIGIN)
      and OGN.START_DATE <= PER2.START_DATE
      and OGN.END_DATE > PER2.START_DATE
    left outer join DIMENSION_VALUES DIM1
      on DIM1.DIMT_CODE = 'RSDTYPE'
      and DIM1.CODE = STC.DIM_RSDTYPE_VALUE
    left outer join DIMENSION_VALUES DIM2
      on DIM2.DIMT_CODE = 'RSDLEVEL'
      and DIM2.CODE = STC.DIM_RSDLEVEL_VALUE)
  loop
    if rSTC.DUPLICATE_NUMBER = 1
    then
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASY',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_START,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASY_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASY-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_START,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASY_AH_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASYAPP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASYAPP, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASYREC-CV',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASYREC_CV, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASYREC-CP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASYREC_CP, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASYREJ',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASYREJ, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASYOTHCL',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASYOTHCL, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASY',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_END,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASY_END, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ASY-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'ASY',
        pnPER_ID => rSTC.PER_ID_END,
        pnDIM_ID1 => rSTC.DIM_ID1,
        pnDIM_ID2 => rSTC.DIM_ID2,
        pnVALUE => nvl(rSTC.ASY_AH_END, 0));
      iCount := iCount + 1;
    else
      dbms_output.put_line('Duplicate Table V statistic record: ' ||
          rSTC.STATSYEAR || '/' || rSTC.COU_CODE_ASYLUM || '/' || rSTC.COU_CODE_ORIGIN || '/' ||
          rSTC.DIM_RSDTYPE_VALUE || '/' || rSTC.DIM_RSDLEVEL_VALUE);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' Table V statistic records inserted');
end;
/
