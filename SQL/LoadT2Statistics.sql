set serveroutput on

declare
  nID P_BASE.tnSTC_ID;
  iCount pls_integer := 0;
begin
  for rSTC in
   (select PER1.ID as PER_ID_START, PER2.ID as PER_ID_END, PER3.ID as PER_ID_YEAR,
      COU.ID as LOC_ID_COUNTRY, OGN.ID as LOC_ID_ORIGIN,
      decode(STC.DISPLACEMENT_STATUS, 'REF-like', 'ROC', 'REF-lilke', 'ROC', 'REF') as DST_CODE,
      STC.POP_START, STC.POP_AH_START,
      STC.ARR_GRP, STC.ARR_IND, STC.ARR_RESTL, STC.BIRTH, STC.REFOTHINC, STC.TOTAL_INCREASE,
      STC.VOLREP, STC.VOLREP_AH, STC.RESTL, STC.RESTL_AH, STC.CESSATION, STC.NATURLZN, STC.DEATH, STC.REFOTHDEC, STC.TOTAL_DECREASE,
      STC.POP_END, STC.POP_AH_END,
      STC.SOURCE, STC.BASIS,
      STC.STATSYEAR, STC.COU_CODE_ASYLUM, STC.COU_CODE_ORIGIN, STC.DISPLACEMENT_STATUS,
      row_number() over (partition by STC.STATSYEAR, COU.ID, OGN.ID, decode(STC.DISPLACEMENT_STATUS, 'REF-like', 'ROC', 'REF') order by 1) as DUPLICATE_NUMBER
    from STAGE.S_ASR_T2 STC
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
      and OGN.END_DATE > PER2.START_DATE)
  loop
    if rSTC.DUPLICATE_NUMBER = 1
    then
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.POP_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.POP_AH_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ARR-GRP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.ARR_GRP, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ARR-IND',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.ARR_IND, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'ARR-RESTL',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.ARR_RESTL, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'BIRTH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.BIRTH, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'REFOTHINC',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.REFOTHINC, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'VOLREP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.VOLREP, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'VOLREP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.VOLREP_AH, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'RESTL',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.RESTL, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'RESTL-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.RESTL_AH, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'CESSATION',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.CESSATION, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'NATURLZN',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.NATURLZN, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'DEATH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.DEATH, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'REFOTHDEC',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.REFOTHDEC, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_END,
        pnVALUE => nvl(rSTC.POP_END, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_END,
        pnVALUE => nvl(rSTC.POP_AH_END, 0));
      iCount := iCount + 1;
    else
      dbms_output.put_line('Duplicate Table II statistic record: ' ||
          rSTC.STATSYEAR || '/' || rSTC.COU_CODE_ASYLUM || '/' || rSTC.COU_CODE_ORIGIN || '/' ||
          rSTC.DISPLACEMENT_STATUS);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' Table II statistic records inserted');
end;
/
