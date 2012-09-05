set serveroutput on

declare
  nID P_BASE.tnSTC_ID;
  iCount pls_integer := 0;
begin
  for rSTC in
   (select PER1.ID as PER_ID_START, PER2.ID as PER_ID_END, PER3.ID as PER_ID_YEAR,
      COU.ID as LOC_ID_COUNTRY, OGN.ID as LOC_ID_ORIGIN, STC.DST_CODE,
      STC.RETURN, STC.RETURN_AH,
      STC.SOURCE, STC.BASIS,
      STC.COU_CODE_ASYLUM, STC.COU_CODE_ORIGIN,
      row_number() over (partition by COU.ID, OGN.ID order by 1) as DUPLICATE_NUMBER
    from STAGE.S_ASR_T7AB STC
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
        psSTCT_CODE => 'RETURN',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => rSTC.RETURN);
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'RETURN-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => rSTC.DST_CODE,
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.RETURN_AH, 0));
      iCount := iCount + 1;
    else
      dbms_output.put_line('Duplicate Table VII.A/B statistic record: ' ||
          rSTC.COU_CODE_ASYLUM || '/' || rSTC.COU_CODE_ORIGIN);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' Table VII.A/B statistic records inserted');
end;
/

declare
  nID P_BASE.tnSTC_ID;
  iCount pls_integer := 0;
begin
  for rSTC in
   (select PER1.ID as PER_ID_START, PER2.ID as PER_ID_END, PER3.ID as PER_ID_YEAR,
      COU.ID as LOC_ID_COUNTRY, OGN.ID as LOC_ID_ORIGIN,
      STC.POP_START, STC.POP_AH_START,
      STC.NATLOSS, STC.STAOTHINC, STC.NATACQ, STC.STAOTHDEC,
      STC.POP_END, STC.POP_AH_END,
      STC.SOURCE, STC.BASIS,
      STC.STATSYEAR, STC.COU_CODE_ASYLUM, STC.COU_CODE_ORIGIN,
      row_number() over (partition by STC.STATSYEAR, COU.ID, OGN.ID order by 1) as DUPLICATE_NUMBER
    from STAGE.S_ASR_T7C STC
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
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.POP_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.POP_AH_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'NATLOSS',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.NATLOSS, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'STAOTHINC',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.STAOTHINC, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'NATACQ',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.NATACQ, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'STAOTHDEC',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.STAOTHDEC, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_END,
        pnVALUE => nvl(rSTC.POP_END, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'STA',
        pnPER_ID => rSTC.PER_ID_END,
        pnVALUE => nvl(rSTC.POP_AH_END, 0));
      iCount := iCount + 1;
    else
      dbms_output.put_line('Duplicate Table VII.C statistic record: ' ||
          rSTC.STATSYEAR || '/' || rSTC.COU_CODE_ASYLUM || '/' || rSTC.COU_CODE_ORIGIN);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' Table VII.C statistic records inserted');
end;
/

declare
  nID P_BASE.tnSTC_ID;
  iCount pls_integer := 0;
begin
  for rSTC in
   (select PER1.ID as PER_ID_START, PER2.ID as PER_ID_END, PER3.ID as PER_ID_YEAR,
      COU.ID as LOC_ID_COUNTRY, OGN.ID as LOC_ID_ORIGIN,
      STC.POP_START, STC.POP_AH_START,
      STC.OOCARR, STC.OOCOTHINC, STC.OOCRTN, STC.OOCOTHDEC,
      STC.POP_END, STC.POP_AH_END,
      STC.SOURCE, STC.BASIS,
      STC.STATSYEAR, STC.COU_CODE_ASYLUM, STC.COU_CODE_ORIGIN,
      row_number() over (partition by STC.STATSYEAR, COU.ID, OGN.ID order by 1) as DUPLICATE_NUMBER
    from STAGE.S_ASR_T7D STC
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
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.POP_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_START,
        pnVALUE => nvl(rSTC.POP_AH_START, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'OOCARR',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.OOCARR, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'OOCOTHINC',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.OOCOTHINC, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'OOCRTN',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.OOCRTN, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'OOCOTHDEC',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_YEAR,
        pnVALUE => nvl(rSTC.OOCOTHDEC, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_END,
        pnVALUE => nvl(rSTC.POP_END, 0));
      iCount := iCount + 1;
    --
      P_STATISTIC.INSERT_STATISTIC
       (nID,
        psSTCT_CODE => 'POP-AH',
        pnLOC_ID_COUNTRY => rSTC.LOC_ID_COUNTRY,
        pnLOC_ID_ORIGIN => rSTC.LOC_ID_ORIGIN,
        psDST_CODE => 'OOC',
        pnPER_ID => rSTC.PER_ID_END,
        pnVALUE => nvl(rSTC.POP_AH_END, 0));
      iCount := iCount + 1;
    else
      dbms_output.put_line('Duplicate Table VII.D statistic record: ' ||
          rSTC.STATSYEAR || '/' || rSTC.COU_CODE_ASYLUM || '/' || rSTC.COU_CODE_ORIGIN);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' Table VII.D statistic records inserted');
end;
/
