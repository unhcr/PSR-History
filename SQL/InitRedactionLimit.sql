set serveroutput on

declare
  nSTG_ID P_BASE.tnSTG_ID;
  iCount pls_integer := 0;
begin
  P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE_TYPE
   ('REDACTLMT', 'N', 'en',
    'Redaction limit (threshold below which small values are redacted from public reports)');
--
  P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP(nSTG_ID, date '2012-01-01', date '2012-01-02');
  P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'REDACTLMT', pnNUM_VALUE => 5);
--
  P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP(nSTG_ID, date '2012-01-01', date '2013-01-01');
  P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'REDACTLMT', pnNUM_VALUE => 5);
--
  P_STATISTIC_GROUP.INSERT_STATISTIC_GROUP(nSTG_ID, date '2012-12-31', date '2013-01-01');
  P_STATISTIC_GROUP.INSERT_STG_ATTRIBUTE(nSTG_ID, 'REDACTLMT', pnNUM_VALUE => 5);
--
  for rSTC in
   (select STC.ID as STC_ID, STG.ID as STG_ID
    from T_STC_GROUP_ATTRIBUTES STGA
    inner join T_STATISTIC_GROUPS STG
      on STG.ID = STGA.STG_ID
    inner join T_STATISTICS STC
      on STC.START_DATE = STG.START_DATE
      and STC.END_DATE = STG.END_DATE
    where STGA.STGAT_CODE = 'REDACTLMT')
  loop
    iCount := iCount + 1;
  --
    P_STATISTIC.INSERT_STATISTIC_IN_GROUP(rSTC.STC_ID, rSTC.STG_ID);
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' STATISTICS_IN_GROUPS records inserted');
end;
/