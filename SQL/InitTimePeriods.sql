execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('YEAR', 'en', 'Year');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('QTR', 'en', 'Quarter');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('MONTH', 'en', 'Month');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('DAY', 'en', 'Day');

declare
  dDay date := date '1950-01-01';
begin
  while dDay < date '2020-01-01'
  loop
    if dDay = trunc(dDay, 'YYYY')
    then P_TIME_PERIOD.INSERT_TIME_PERIOD(dDay, add_months(dDay, 12), 'YEAR');
    end if;
  --
    if dDay = trunc(dDay, 'Q')
    then P_TIME_PERIOD.INSERT_TIME_PERIOD(dDay, add_months(dDay, 3), 'QTR');
    end if;
  --
    if dDay = trunc(dDay, 'MM')
    then P_TIME_PERIOD.INSERT_TIME_PERIOD(dDay, add_months(dDay, 1), 'MONTH');
    end if;
  --
    P_TIME_PERIOD.INSERT_TIME_PERIOD(dDay, dDay + 1, 'DAY');
  --
    dDay := dDay + 1;
  end loop;
end;
/
