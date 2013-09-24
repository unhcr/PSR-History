set serveroutput on

declare
  nPPG_ID P_BASE.tnPPG_ID;
  iCount pls_integer := 0;
begin
  for rPPG in
   (select PPG.PPG_CODE, PPG.START_DATE, PPG.END_DATE, PPG.DESCRIPTION, PPG.OPERATION,
      LOC.ID as LOC_ID
    from STAGE.S_PPGS PPG
    left outer join LOCATION_ATTRIBUTES LOCA
      on LOCA.CHAR_VALUE = PPG.OPERATION
      and LOCA.LOCAT_CODE = 'HCRCD'
    left outer join LOCATIONS LOC
      on LOC.ID = LOCA.LOC_ID
      and LOC.LOCT_CODE = 'HCR-ROF'
    order by PPG_CODE)
  loop
    iCount := iCount + 1;
  --
    if rPPG.LOC_ID is not null
    then
      P_POPULATION_PLANNING_GROUP.INSERT_PPG
       (nPPG_ID, 'en', rPPG.DESCRIPTION, rPPG.LOC_ID, rPPG.PPG_CODE, rPPG.START_DATE, rPPG.END_DATE);
    else
      P_POPULATION_PLANNING_GROUP.INSERT_PPG
       (nPPG_ID, 'en', rPPG.DESCRIPTION, rPPG.OPERATION, rPPG.PPG_CODE, rPPG.START_DATE, rPPG.END_DATE);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' POPULATION_PLANNING_GROUPS records inserted');
end;
/
