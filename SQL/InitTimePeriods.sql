execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('YEAR', 'en', 'Year');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('QTR', 'en', 'Quarter');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('MONTH', 'en', 'Month');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('DAY', 'en', 'Day');

declare
  nID P_BASE.tnPER_ID;
  dDay date := date '2000-01-01';
begin
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
/
