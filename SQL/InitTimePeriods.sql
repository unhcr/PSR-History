/*
declare
  nID P_BASE.tnPER_ID;
  dDay date := date '2000-01-01';
begin
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('YEAR', 'en', 'Year');
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('QTR', 'en', 'Quarter');
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('MONTH', 'en', 'Month');
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('DAY', 'en', 'Day');
--
  while dDay < date '2020-01-01'
  loop
    if dDay = trunc(dDay, 'YYYY')
    then P_TIME_PERIOD.INSERT_TIME_PERIOD(nID, 'YEAR', dDay, add_months(dDay, 12));
    end if;
  --
    if dDay = trunc(dDay, 'Q')
    then P_TIME_PERIOD.INSERT_TIME_PERIOD(nID, 'QTR', dDay, add_months(dDay, 3));
    end if;
  --
    if dDay = trunc(dDay, 'MM')
    then P_TIME_PERIOD.INSERT_TIME_PERIOD(nID, 'MONTH', dDay, add_months(dDay, 1));
    end if;
  --
    P_TIME_PERIOD.INSERT_TIME_PERIOD(nID, 'DAY', dDay, dDay + 1);
  --
    dDay := dDay + 1;
  end loop;
end;
*/

declare
  dDay date := date '2000-01-01';
begin
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('YEAR', 'en', 'Year');
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('QTR', 'en', 'Quarter');
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('MONTH', 'en', 'Month');
  P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('DAY', 'en', 'Day');
--
  while dDay < date '2020-01-01'
  loop
    if dDay = trunc(dDay, 'YYYY')
    then
      insert into T_TIME_PERIODS (ID, PERT_CODE, START_DATE, END_DATE)
      values (PER_SEQ.nextval, 'YEAR', dDay, add_months(dDay, 12));
    end if;
  --
    if dDay = trunc(dDay, 'Q')
    then
      insert into T_TIME_PERIODS (ID, PERT_CODE, START_DATE, END_DATE)
      values (PER_SEQ.nextval, 'QTR', dDay, add_months(dDay, 3));
    end if;
  --
    if dDay = trunc(dDay, 'MM')
    then
      insert into T_TIME_PERIODS (ID, PERT_CODE, START_DATE, END_DATE)
      values (PER_SEQ.nextval, 'MONTH', dDay, add_months(dDay, 1));
    end if;
  --
    insert into T_TIME_PERIODS (ID, PERT_CODE, START_DATE, END_DATE)
    values (PER_SEQ.nextval, 'DAY', dDay, dDay + 1);
  --
    dDay := dDay + 1;
  end loop;
end;
/
