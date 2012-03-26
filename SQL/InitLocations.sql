variable LOC_CODE1 number;
variable LOC_CODE2 number;
variable VERSION_NBR number

-- Location types
execute LOCATION.INSERT_LOCATION_TYPE('COUNTRY', 'en', 'Country');
execute LOCATION.INSERT_LOCATION_TYPE('UNREG', 'en', 'UN Region');
execute LOCATION.INSERT_LOCATION_TYPE('UNSUBREG', 'en', 'UN Subregion');

-- Location attribute types
execute LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166A3', 'C', 'en', 'ISO 3166-1 Alpha-3 country code');
execute LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166A2', 'C', 'en', 'ISO 3166-1 Alpha-2 country code');
execute LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('IS03166NUM', 'C', 'en', 'ISO 3166-1 Numeric country code');
execute LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('UNHCRCC', 'C', 'en', 'UNHCR country code');

-- Location relationship types
execute LOCATION.INSERT_LOC_RELATIONSHIP_TYPE('WITHIN', 'en', 'Divided into / Within');

-- UN Regions, UN Subregions and Countries
/*
execute LOCATION.INSERT_LOCATION(:LOC_CODE1, 'en', 'Africa', 'UNREG');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Eastern Africa', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Middle Africa', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Northern Africa', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Southern Africa', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Western Africa', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE1, 'en', 'Americas', 'UNREG');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Caribbean', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Central America', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Northern America', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'South America', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE1, 'en', 'Asia', 'UNREG');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Central Asia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Eastern Asia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'South-Eastern Asia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Southern Asia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Western Asia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE1, 'en', 'Europe', 'UNREG');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Eastern Europe', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Northern Europe', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Southern Europe', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Western Europe', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE1, 'en', 'Oceania', 'UNREG');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Australia and New Zealand', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Melanesia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Micronesia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
execute LOCATION.INSERT_LOCATION(:LOC_CODE2, 'en', 'Polynesia', 'UNSUBREG');
execute LOCATION.INSERT_LOCATION_RELATIONSHIP(:LOC_CODE1, :LOC_CODE2, 'WITHIN');
*/

declare
  nLOC_CODE_REG LOCATION.tnLOC_CODE;
  nLOC_CODE_SUB LOCATION.tnLOC_CODE;
  nLOC_CODE_COU LOCATION.tnLOC_CODE;
  nVERSION_NBR LOCATION.tnLOC_VERSION_NBR;
  nSEQ_NBR LOCATION.tnTXI_SEQ_NBR;
begin
  for rREG in
   (select distinct UN_REGION
    from STAGE.COUNTRIES
    where UN_REGION is not null
    order by UN_REGION)
  loop
    LOCATION.INSERT_LOCATION(nLOC_CODE_REG, 'en', rREG.UN_REGION, 'UNREG');
  --
    for rSUB in
     (select distinct UN_SUBREGION
      from STAGE.COUNTRIES
      where UN_REGION = rREG.UN_REGION
      order by UN_SUBREGION)
    loop
      LOCATION.INSERT_LOCATION(nLOC_CODE_SUB, 'en', rSUB.UN_SUBREGION, 'UNSUBREG');
      LOCATION.INSERT_LOCATION_RELATIONSHIP(nLOC_CODE_REG, nLOC_CODE_SUB, 'WITHIN');
    --
      for rCOU in
       (select UN_REGION, UN_SUBREGION, COUNTRY_NAME, NAME_LANGUAGE, ISO_A3, ISO_A2, ISO_N, UNHCR, FORMAL_NAME
        from STAGE.COUNTRIES
        where UN_REGION = rREG.UN_REGION
        and UN_SUBREGION = rSUB.UN_SUBREGION
        order by COUNTRY_NAME)
      loop
        LOCATION.INSERT_LOCATION(nLOC_CODE_COU, rCOU.NAME_LANGUAGE, rCOU.COUNTRY_NAME, 'COUNTRY', rCOU.ISO_A3);
        LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_CODE_COU, 'IS03166A2', rCOU.ISO_A2);
        LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_CODE_COU, 'IS03166NUM', lpad(rCOU.ISO_N, 3, '0'));
        if rCOU.UNHCR is not null
        then LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_CODE_COU, 'UNHCRCC', rCOU.UNHCR);
        end if;
        nVERSION_NBR := 1;
        nSEQ_NBR := null;
        LOCATION.SET_LOC_TEXT(nLOC_CODE_COU, nVERSION_NBR, 'FORMALNAME', nSEQ_NBR, 'en', rCOU.FORMAL_NAME);
        LOCATION.INSERT_LOCATION_RELATIONSHIP(nLOC_CODE_SUB, nLOC_CODE_COU, 'WITHIN');
      end loop;
    end loop;
  end loop;
--
  for rCOU in
   (select UN_REGION, UN_SUBREGION, COUNTRY_NAME, NAME_LANGUAGE, ISO_A3, ISO_A2, ISO_N, UNHCR, FORMAL_NAME
    from STAGE.COUNTRIES
    where UN_REGION is null
    order by COUNTRY_NAME)
  loop
    LOCATION.INSERT_LOCATION(nLOC_CODE_COU, rCOU.NAME_LANGUAGE, rCOU.COUNTRY_NAME, 'COUNTRY', rCOU.ISO_A3);
    LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_CODE_COU, 'IS03166A2', rCOU.ISO_A2);
    LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_CODE_COU, 'IS03166NUM', lpad(rCOU.ISO_N, 3, '0'));
    if rCOU.UNHCR is not null
    then LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_CODE_COU, 'UNHCRCC', rCOU.UNHCR);
    end if;
  end loop;
end;
/
