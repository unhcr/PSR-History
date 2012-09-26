set serveroutput on

declare
  nVERSION_NBR P_BASE.tnPSGAT_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rPSGAT in
   (select CODE, DESCRIPTION_EN, DATA_TYPE, DISPLAY_SEQ, DESCRIPTION_FR, NOTES
    from STAGE.S_POPSEG_ATTRIBUTE_TYPES)
  loop
    nCount := nCount + 1;
  --
    P_POPULATION_SEGMENT.INSERT_POPSEG_ATTRIBUTE_TYPE(rPSGAT.CODE, rPSGAT.DATA_TYPE, 'en', rPSGAT.DESCRIPTION_EN, rPSGAT.DISPLAY_SEQ);
    nVERSION_NBR := 1;
  --
    if rPSGAT.DESCRIPTION_FR is not null
    then
      P_POPULATION_SEGMENT.SET_PSGAT_DESCRIPTION(rPSGAT.CODE, nVERSION_NBR, 'fr', rPSGAT.DESCRIPTION_FR);
    end if;
  --
    if rPSGAT.NOTES is not null
    then
      nSEQ_NBR := null;
      P_POPULATION_SEGMENT.SET_PSGAT_TEXT(rPSGAT.CODE, nVERSION_NBR, 'NOTE', nSEQ_NBR, 'en', rPSGAT.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' POPSEG_ATTRIBUTE_TYPES records inserted');
end;
/
