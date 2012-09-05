set serveroutput on

declare
  nVERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rSTCG in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STATISTIC_GROUPS)
  loop
    iCount := iCount + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_GROUP(rSTCG.CODE, 'en', rSTCG.DESCRIPTION_EN, rSTCG.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rSTCG.DESCRIPTION_FR is not null
    then
      P_STATISTIC_TYPE.SET_STCG_DESCRIPTION(rSTCG.CODE, nVERSION_NBR, 'fr', rSTCG.DESCRIPTION_FR);
    end if;
  --
    if rSTCG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCG_TEXT(rSTCG.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCG.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' STATISTIC_GROUPS records inserted');
end;
/

declare
  nVERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rSTCT in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STATISTIC_TYPES)
  loop
    iCount := iCount + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE(rSTCT.CODE, 'en', rSTCT.DESCRIPTION_EN, rSTCT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rSTCT.DESCRIPTION_FR is not null
    then
      P_STATISTIC_TYPE.SET_STCT_DESCRIPTION(rSTCT.CODE, nVERSION_NBR, 'fr', rSTCT.DESCRIPTION_FR);
    end if;
  --
    if rSTCT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCT_TEXT(rSTCT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' STATISTIC_TYPES records inserted');
end;
/

declare
  nVERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rSTCTG in
   (select STCG_CODE, STCT_CODE, NOTES
    from STAGE.S_STATISTIC_TYPES_IN_GROUPS)
  loop
    iCount := iCount + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING(rSTCTG.STCG_CODE, rSTCTG.STCT_CODE);
    nVERSION_NBR := 1;
  --
    if rSTCTG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCTG_TEXT(rSTCTG.STCG_CODE, rSTCTG.STCT_CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCTG.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' STATISTIC_TYPES_IN_GROUPS records inserted');
end;
/
