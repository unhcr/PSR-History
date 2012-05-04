set serveroutput on

variable LOC_ID1 number;
variable LOC_ID2 number;
variable VERSION_NBR number

-- Location types
execute P_LOCATION.INSERT_LOCATION_TYPE('COUNTRY', 'en', 'Country');
execute P_LOCATION.INSERT_LOCATION_TYPE('OTHORIGIN', 'en', 'Other Origin');
execute P_LOCATION.INSERT_LOCATION_TYPE('UNREG', 'en', 'UN Region');
execute P_LOCATION.INSERT_LOCATION_TYPE('UNSUBREG', 'en', 'UN Subregion');
execute P_LOCATION.INSERT_LOCATION_TYPE('HCRBUR', 'en', 'UNHCR Bureau');
execute P_LOCATION.INSERT_LOCATION_TYPE('HCROPN', 'en', 'UNHCR Operation');
execute P_LOCATION.INSERT_LOCATION_TYPE('POINT', 'en', 'Point');
execute P_LOCATION.INSERT_LOCATION_TYPE('ADMIN1', 'en', 'Level 1 administrative division');
execute P_LOCATION.INSERT_LOCATION_TYPE('ADMIN2', 'en', 'Level 2 administrative division');

-- Location attribute types
execute P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166A3', 'C', 'en', 'ISO 3166-1 Alpha-3 country code');
execute P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166A2', 'C', 'en', 'ISO 3166-1 Alpha-2 country code');
execute P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166NUM', 'C', 'en', 'ISO 3166-1 Numeric country code');
execute P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('UNHCRCC', 'C', 'en', 'UNHCR country code');
execute P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166_2', 'C', 'en', 'ISO 3166-2 subdivision code');

-- Location relationship types
execute P_LOCATION.INSERT_LOC_RELATIONSHIP_TYPE('WITHIN', 'en', 'Divided into / Within');

-- UN Regions and Subregions
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Africa', 'UNREG');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Eastern Africa', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Middle Africa', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Northern Africa', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Southern Africa', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Western Africa', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Americas', 'UNREG');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Caribbean', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Central America', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Northern America', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'South America', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Asia', 'UNREG');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Central Asia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Eastern Asia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'South-Eastern Asia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Southern Asia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Western Asia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Europe', 'UNREG');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Eastern Europe', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Northern Europe', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Southern Europe', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Western Europe', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Oceania', 'UNREG');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Australia and New Zealand', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Melanesia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Micronesia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Polynesia', 'UNSUBREG');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');

-- UNHCR Bureaux and Operations
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Africa', 'HCRBUR');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Central Africa and the Great Lakes (CA-GL)', 'HCROPN');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'East and Horn of Africa (EHA)', 'HCROPN');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'Southern Africa (SAO)', 'HCROPN');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID2, 'en', 'West Africa (WA)', 'HCROPN');
execute P_LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_ID1, :LOC_ID2, 'WITHIN');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Middle East and North Africa (MENA)', 'HCRBUR');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'The Americas (RBAC)', 'HCRBUR');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Asia and Pacific (RBAP)', 'HCRBUR');
execute P_LOCATION.INSERT_LOCATION(:LOC_ID1, 'en', 'Europe (RBE)', 'HCRBUR');

-- Countries (from spreadsheet constructed from CommonDataHub "ISO 3166 Country Codes" and UNHCR Style Companion
declare
  nLOC_ID_COU P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rCOU in
   (select COU.COUNTRY_NAME, COU.NAME_LANGUAGE, COU.ISO_A3, COU.ISO_A2, COU.ISO_N, COU.UNHCR, COU.FORMAL_NAME, SUB.ID LOC_ID_SUB, BOP.ID LOC_ID_BOP
    from STAGE.COUNTRIES COU
    left outer join L_LOCATIONS SUB
    on SUB.NAME = COU.UN_SUBREGION
    and SUB.LOCT_CODE = 'UNSUBREG'
    left outer join L_LOCATIONS BOP
    on BOP.NAME = COU.UNHCR_BUR_OPN
    and BOP.LOCT_CODE in ('HCRBUR', 'HCROPN')
    order by COU.COUNTRY_NAME)
  loop
    nCount := nCount + 1;
  --
    P_LOCATION.INSERT_LOCATION(nLOC_ID_COU, rCOU.NAME_LANGUAGE, rCOU.COUNTRY_NAME, 'COUNTRY', rCOU.ISO_A3);
  --
    P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'IS03166A2', rCOU.ISO_A2);
    P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'IS03166NUM', lpad(rCOU.ISO_N, 3, '0'));
    if rCOU.UNHCR is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'UNHCRCC', rCOU.UNHCR);
    end if;
  --
    nVERSION_NBR := 1;
    nSEQ_NBR := null;
    P_LOCATION.SET_LOC_TEXT(nLOC_ID_COU, nVERSION_NBR, 'FORMALNAME', nSEQ_NBR, 'en', rCOU.FORMAL_NAME);
  --
    if rCOU.LOC_ID_SUB is not null
    then P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rCOU.LOC_ID_SUB, nLOC_ID_COU, 'WITHIN');
    end if;
  --
    if rCOU.LOC_ID_BOP is not null
    then P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rCOU.LOC_ID_BOP, nLOC_ID_COU, 'WITHIN');
    end if;
  end loop;
--
  P_LOCATION.INSERT_LOCATION(nLOC_ID_COU, 'en', 'Tibetan', 'OTHORIGIN');
  P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'UNHCRCC', 'TIB');
  P_LOCATION.INSERT_LOCATION(nLOC_ID_COU, 'en', 'Chechnyan', 'OTHORIGIN');
  P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'UNHCRCC', 'CHY');
  P_LOCATION.INSERT_LOCATION(nLOC_ID_COU, 'en', 'Kosovo (S/RES/1244 (1999))', 'OTHORIGIN');
  P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'UNHCRCC', 'KOS');
  P_LOCATION.INSERT_LOCATION(nLOC_ID_COU, 'en', 'Stateless', 'OTHORIGIN');
  P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID_COU, 'UNHCRCC', 'STA');
--
  dbms_output.put_line(to_char(nCount) || ' country records inserted');
end;
/

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
    join L_COUNTRIES COU
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
    join L_COUNTRIES COU
    on COU.ISO3166_ALPHA3_CODE = DIV.ISO3166_1_A3
    left outer join L_LOCATION_TYPE_VARIANTS LOCTV
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
      join L_COUNTRIES COU
      on COU.UNHCR_COUNTRY_CODE = DEM.COUNTRY_CODE) DEM1
    where not exists
     (select null
      from L_HIERARCHICAL_LOCATIONS HLOC
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
