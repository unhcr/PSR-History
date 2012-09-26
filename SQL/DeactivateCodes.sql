set serveroutput on

declare
  nVERSION_NBR P_BASE.tnDIM_VERSION_NBR;
  iCount pls_integer := 0;
begin
  for rDIM in
   (select DIM.ID as DIM_ID, DIM.VERSION_NBR
    from STAGE.S_DIMENSION_VALUES STG
    join DIMENSION_VALUES DIM
      on DIM.DIMT_CODE = STG.DIMT_CODE
      and DIM.CODE = STG.CODE
    where STG.ACTIVE_FLAG = 'N')
  loop
    iCount := iCount + 1;
    P_DIMENSION.UPDATE_DIMENSION_VALUE(rDIM.DIM_ID, rDIM.VERSION_NBR, psACTIVE_FLAG => 'N');
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' DIMENSION_VALUES records inactivated');
end;
/
