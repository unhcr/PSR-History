set serveroutput on

-- Country first-level subdivisions and dependant areas as specified by the ISO 3166-2 standard obtained from CommonDataHub "ISO 3166-2 State Codes".
declare
  nLOCTV_ID P_BASE.tnLOCTV_ID;
  nLOC_ID_DIV P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  nCount pls_integer := 0;
begin
  for rDIV in
   (select distinct DIV.ISO3166_1_A3, DIV.LEVEL_NAME, COU.ID
    from STAGE.SUBDIVISIONS DIV
    join COUNTRIES COU
      on COU.ISO3166_ALPHA3_CODE = DIV.ISO3166_1_A3
    where DIV.LEVEL_NAME is not null
    order by ISO3166_1_A3, LEVEL_NAME)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOCATION_TYPE_VARIANT(nLOCTV_ID, 'en', rDIV.LEVEL_NAME, 'ADMIN1', rDIV.ID, 'WITHIN');
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' location type variant records inserted');
--
  nCount := 0;
--
  for rDIV in
   (select DIV.ISO3166_2, nvl(DIV.NAME, 'Unknown') NAME, COU.ID, LOCTV.ID LOCTV_ID
    from STAGE.SUBDIVISIONS DIV
    join COUNTRIES COU
    on COU.ISO3166_ALPHA3_CODE = DIV.ISO3166_1_A3
    left outer join LOCATION_TYPE_VARIANTS LOCTV
      on LOCTV.LOCT_CODE = 'ADMIN1'
      and LOCTV.LOC_ID = COU.ID
      and LOCTV.LOCRT_CODE = 'WITHIN'
      and LOCTV.DESCRIPTION = DIV.LEVEL_NAME
    order by DIV.ISO3166_1_A3, DIV.ISO3166_2)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOCATION(nLOC_ID_DIV, 'en', rDIV.NAME, 'ADMIN1');
  --
    P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_DIV, 'IS03166_2', rDIV.ISO3166_2);
  --
    P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rDIV.ID, nLOC_ID_DIV, 'WITHIN');
  --
    if rDIV.LOCTV_ID is not null
    then
      nVERSION_NBR := 1;
      P_LOCATION.UPDATE_LOCATION(nLOC_ID_DIV, nVERSION_NBR, pnLOCTV_ID => rDIV.LOCTV_ID);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' ISO subdivision records inserted');
end;
/

declare
  nLOC_ID_DEM P_BASE.tnLOC_ID;
  nCount pls_integer := 0;
begin
  for rDEM in
   (select DEM1.NAME, DEM1.ID
    from
     (select distinct regexp_replace(nvl(DEM.LOC_NAME, DEM.LOC_NAME_NEW), ' : .*$', '') NAME, COU.ID
      from STAGE.DEMOGRAPHICS_2010 DEM
      join COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = DEM.COUNTRY_CODE) DEM1
    where not exists
     (select null
      from HIERARCHICAL_LOCATIONS HLOC
      where HLOC.LOC_ID_FROM = DEM1.ID
      and nlssort(HLOC.NAME, 'NLS_SORT=BINARY_AI') = nlssort(DEM1.NAME, 'NLS_SORT=BINARY_AI'))
    order by 2, 1)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOCATION(nLOC_ID_DEM, 'en', rDEM.NAME, 'ADMIN1');
  --
    P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rDEM.ID, nLOC_ID_DEM, 'WITHIN');
  end loop;
--
  dbms_output.put_line(to_char(nCount) || ' ASR subdivision records inserted');
end;
/
