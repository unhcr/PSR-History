set serveroutput on

declare
  nVERSION_NBR P_BASE.tnPGRAT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rPGRAT in
   (select CODE, DESCRIPTION_EN, DATA_TYPE, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_POP_GROUP_ATTRIBUTE_TYPES)
  loop
    nCount := nCount + 1;
  --
    P_POPULATION_GROUP.INSERT_PGR_ATTRIBUTE_TYPE(rPGRAT.CODE, rPGRAT.DATA_TYPE, 'en', rPGRAT.DESCRIPTION_EN, rPGRAT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rPGRAT.DESCRIPTION_FR is not null
    then
      P_POPULATION_GROUP.SET_PGRAT_DESCRIPTION(rPGRAT.CODE, nVERSION_NBR, 'fr', rPGRAT.DESCRIPTION_FR);
    end if;
  --
    if rPGRAT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_POPULATION_GROUP.SET_PGRAT_TEXT(rPGRAT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rPGRAT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' POP_GROUP_ATTRIBUTE_TYPES records inserted');
end;
/
