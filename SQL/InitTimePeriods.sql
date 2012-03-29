execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('YEAR', 'en', 'Year');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('QTR', 'en', 'Quarter');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('MONTH', 'en', 'Month');
execute P_TIME_PERIOD.INSERT_TIME_PERIOD_TYPE('DAY', 'en', 'Day');

declare
  dDay date := date '1950-01-01';
begin
  for nYear in 1950..2020
  loop
    P_TIME_PERIOD.INSERT_TIME_PERIOD(add_months(date '0001-01-01', 12 * (nYear-1)), add_months(date '0001-01-01', 12 * nYear), 'YEAR');
  --
    for nQtr in 1..4
    loop
      P_TIME_PERIOD.INSERT_TIME_PERIOD(add_months(date '0001-01-01', (12 * (nYear-1)) + (3 * (nQtr-1))), add_months(date '0001-01-01', (12 * (nYear-1)) + (3 * nQtr)), 'QTR');
    end loop;
  --
    for nMonth in 1..12
    loop
      P_TIME_PERIOD.INSERT_TIME_PERIOD(add_months(date '0001-01-01', (12 * (nYear-1)) + (nMonth-1)), add_months(date '0001-01-01', (12 * (nYear-1)) + nMonth), 'MONTH');
    end loop;
  end loop;
--
  while dDay < date '2020-01-01'
  loop
    P_TIME_PERIOD.INSERT_TIME_PERIOD(dDay, dDay + 1, 'DAY');
    dDay := dDay + 1;
  end loop;
end;
/
