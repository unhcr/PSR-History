execute P_LOCATION.INSERT_LOCATION_TYPE('HCRBUDOPN', 'en', 'Operation');
execute P_LOCATION.INSERT_LOCATION_ATTRIBUTE_TYPE('FOCUSID', 'C', 'en', 'Focus identifier');
execute P_LOCATION.INSERT_LOC_RELATIONSHIP_TYPE('COVER', 'en', 'Covers / Covered by');

-- Load Operations
declare
  sCountryList varchar2(1000);
  nLOC_ID P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
begin
  for rOPN in
   (select OPN.OPERATION_ID, OPN.OPN_START_DATE, OPN.COUNTRY_COUNT, OPN.COUNTRY_ROW, OPN.ISO3166_ALPHA3_CODE, COU.ID, COU.NAME
    from STAGE.OPERATIONS OPN
    join COUNTRIES COU
      on COU.ISO3166_ALPHA3_CODE = OPN.ISO3166_ALPHA3_CODE
    order by OPERATION_ID, COUNTRY_ROW)
  loop
    if rOPN.COUNTRY_ROW = 1
    then P_LOCATION.INSERT_LOCATION(nLOC_ID, 'en', rOPN.NAME || ' operation', 'HCRBUDOPN', pdSTART_DATE => nvl(rOPN.OPN_START_DATE, P_BASE.MIN_DATE));
      P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'FOCUSID', rOPN.OPERATION_ID);
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(nLOC_ID, rOPN.ID, 'COVER');
      sCountryList := rOPN.NAME;
    else
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(nLOC_ID, rOPN.ID, 'COVER');
      sCountryList := sCountryList || ' / ' || rOPN.NAME;
    --
      if rOPN.COUNTRY_ROW = rOPN.COUNTRY_COUNT
      then
        nVERSION_NBR := 1;
        P_LOCATION.UPDATE_LOCATION(nLOC_ID, nVERSION_NBR, 'en', sCountryList || ' operation');
      end if;
    end if;
  end loop;
end;
/

-- Load PPGs
declare
  nPPG_ID P_BASE.tnPPG_ID;
begin
  for rPPG in
   (select PPG.MSRPCODE, nvl(trunc(PPG.EFFFROMDT), LOC.START_DATE) START_DATE, nvl(trunc(PPG.EFFTODT), LOC.END_DATE) END_DATE, PPG.NAME, LOCA.LOC_ID
    from STAGE.FOCUS_PPGS PPG
    join T_LOCATION_ATTRIBUTES LOCA
      on LOCA.LOCAT_CODE = 'FOCUSID'
      and LOCA.CHAR_VALUE = PPG.OPERATION_ID
    join T_LOCATIONS LOC
      on LOC.ID = LOCA.LOC_ID
    order by PPG.MSRPCODE)
  loop
    P_POPULATION_PLANNING_GROUP.INSERT_PPG(nPPG_ID, 'en', rPPG.NAME, rPPG.LOC_ID, rPPG.MSRPCODE, rPPG.START_DATE, rPPG.END_DATE);
  end loop;
end;
/
