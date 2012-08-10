set serveroutput on

-- Countries (from spreadsheet constructed from CommonDataHub "ISO 3166 Country Codes", UNHCR Style Companion, and UNHCR Global Trends 2010 Annexes, Table 26)
declare
  nLOC_ID_COU P_BASE.tnLOC_ID;
  nVERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  nCount pls_integer := 0;
begin
  for rCOU in
   (select COU.COUNTRY_NAME, COU.NAME_LANGUAGE, COU.ISO_A3, COU.ISO_A2, COU.ISO_N, COU.UNHCR, COU.FORMAL_NAME, SUB.ID LOC_ID_SUB, BOP.ID LOC_ID_BOP
    from STAGE.COUNTRIES COU
    left outer join LOCATIONS SUB
    on SUB.NAME = COU.UN_SUBREGION
    and SUB.LOCT_CODE = 'UNSUBREG'
    left outer join LOCATIONS BOP
    on BOP.NAME = COU.UNHCR_BUR_OPN
    and BOP.LOCT_CODE in ('HCRBUR', 'HCRREGOP')
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
    then P_LOCATION.INSERT_LOCATION_RELATIONSHIP(rCOU.LOC_ID_BOP, nLOC_ID_COU, 'RESP');
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
