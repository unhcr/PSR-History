set serveroutput on

declare
  nSTCG_VERSION_NBR P_BASE.tnSTCG_VERSION_NBR;
  nSTCT_VERSION_NBR P_BASE.tnSTCT_VERSION_NBR;
  nSTCTG_VERSION_NBR P_BASE.tnSTCTG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount1 pls_integer := 0;
  iCount2 pls_integer := 0;
  iCount3 pls_integer := 0;
begin
  for rSTCG in
   (select CODE, DESCRIPTION_EN, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STATISTIC_GROUPS)
  loop
    iCount1 := iCount1 + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_GROUP
     (rSTCG.CODE, 'en', rSTCG.DESCRIPTION_EN, rSTCG.DISPLAY_SEQ);
    nSTCG_VERSION_NBR := 1;
  --
    if rSTCG.DESCRIPTION_FR is not null
    then
      P_STATISTIC_TYPE.SET_STCG_DESCRIPTION
       (rSTCG.CODE, nSTCG_VERSION_NBR, 'fr', rSTCG.DESCRIPTION_FR);
    end if;
  --
    if rSTCG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCG_TEXT
       (rSTCG.CODE, nSTCG_VERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCG.NOTES);
    end if;
  end loop;
--
  for rSTCT in
   (select CODE, DESCRIPTION_EN, DST_CODE_FLAG,
      LOC_ID_ASYLUM_COUNTRY_FLAG, LOC_ID_ASYLUM_FLAG,
      LOC_ID_ORIGIN_COUNTRY_FLAG, LOC_ID_ORIGIN_FLAG,
      DIM_ID1_FLAG, DIMT_CODE1, DIM_ID2_FLAG, DIMT_CODE2, DIM_ID3_FLAG, DIMT_CODE3,
      DIM_ID4_FLAG, DIMT_CODE4, DIM_ID5_FLAG, DIMT_CODE5, SEX_CODE_FLAG, AGR_ID_FLAG,
      PGR_ID_SUBGROUP_FLAG, STCG_CODE1, STCG_CODE2, STCG_CODE3, STCG_CODE4,
      DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_STATISTIC_TYPES)
  loop
    iCount2 := iCount2 + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE
     (rSTCT.CODE, 'en', rSTCT.DESCRIPTION_EN, rSTCT.DST_CODE_FLAG,
      rSTCT.LOC_ID_ASYLUM_COUNTRY_FLAG, rSTCT.LOC_ID_ASYLUM_FLAG,
      rSTCT.LOC_ID_ORIGIN_COUNTRY_FLAG, rSTCT.LOC_ID_ORIGIN_FLAG,
      rSTCT.DIM_ID1_FLAG, rSTCT.DIMT_CODE1, rSTCT.DIM_ID2_FLAG, rSTCT.DIMT_CODE2,
      rSTCT.DIM_ID3_FLAG, rSTCT.DIMT_CODE3, rSTCT.DIM_ID4_FLAG, rSTCT.DIMT_CODE4,
      rSTCT.DIM_ID5_FLAG, rSTCT.DIMT_CODE5, rSTCT.SEX_CODE_FLAG, rSTCT.AGR_ID_FLAG,
      rSTCT.PGR_ID_SUBGROUP_FLAG, rSTCT.DISPLAY_SEQ);
    nSTCT_VERSION_NBR := 1;
  --
    if rSTCT.STCG_CODE1 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING(rSTCT.STCG_CODE1, rSTCT.CODE);
    end if;
  --
    if rSTCT.STCG_CODE2 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING(rSTCT.STCG_CODE2, rSTCT.CODE);
    end if;
  --
    if rSTCT.STCG_CODE3 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING(rSTCT.STCG_CODE3, rSTCT.CODE);
    end if;
  --
    if rSTCT.STCG_CODE4 is not null
    then
      iCount3 := iCount3 + 1;
      P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING(rSTCT.STCG_CODE4, rSTCT.CODE);
    end if;
  --
    if rSTCT.DESCRIPTION_FR is not null
    then
      P_STATISTIC_TYPE.SET_STCT_DESCRIPTION
       (rSTCT.CODE, nSTCT_VERSION_NBR, 'fr', rSTCT.DESCRIPTION_FR);
    end if;
  --
    if rSTCT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCT_TEXT
       (rSTCT.CODE, nSTCT_VERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCT.NOTES);
    end if;
  end loop;
--
  for rSTCTG in
   (select STCG_CODE, STCT_CODE, NOTES
    from STAGE.S_STATISTIC_TYPES_IN_GROUPS
    where (STCG_CODE, STCT_CODE) not in
     (select STCG_CODE, STCT_CODE
      from T_STATISTIC_TYPES_IN_GROUPS))
  loop
    iCount3 := iCount3 + 1;
  --
    P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING(rSTCTG.STCG_CODE, rSTCTG.STCT_CODE);
    nSTCTG_VERSION_NBR := 1;
  --
    if rSTCTG.NOTES is not null
    then
      nSEQ_NBR := null;
      P_STATISTIC_TYPE.SET_STCTG_TEXT
       (rSTCTG.STCG_CODE, rSTCTG.STCT_CODE, nSTCTG_VERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rSTCTG.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount1) || ' STATISTIC_GROUPS records inserted');
  dbms_output.put_line(to_char(iCount2) || ' STATISTIC_TYPES records inserted');
  dbms_output.put_line(to_char(iCount3) || ' STATISTIC_TYPES_IN_GROUPS records inserted');
end;
/
