set serveroutput on

declare
  type tanLOC_ID is table of P_BASE.tnLOC_ID index by pls_integer;
  anLOC_ID tanLOC_ID;
  nLOC_ID P_BASE.tnLOC_ID;
  nLOC_VERSION_NBR P_BASE.tnLOC_VERSION_NBR;
  nTXT_SEQ_NBR P_BASE.tnTXT_SEQ_NBR;
  iCount pls_integer := 0;
begin
  for rLOC in
   (select KEY, NAME_EN, LOCT_CODE, START_DATE, END_DATE, NAME_FR, UNSDNUM, HCRBC, DISPLAYSEQ, RSKEY, NOTES
    from STAGE.S_LOCATIONS_REGIONS
    order by KEY)
  loop
    iCount := iCount + 1;
    P_LOCATION.INSERT_LOCATION
     (nLOC_ID, 'en', rLOC.NAME_EN, rLOC.LOCT_CODE,
      pdSTART_DATE => rLOC.START_DATE, pdEND_DATE => rLOC.END_DATE);
    anLOC_ID(rLOC.KEY) := nLOC_ID;
    nLOC_VERSION_NBR := 1;
  --
    if rLOC.NAME_FR is not null
    then P_LOCATION.SET_LOC_NAME(nLOC_ID, nLOC_VERSION_NBR, 'fr', rLOC.NAME_FR);
    end if;
  --
    if rLOC.UNSDNUM is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'UNSDNUM', rLOC.UNSDNUM);
    end if;
  --
    if rLOC.HCRBC is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'HCRBC', rLOC.HCRBC);
    end if;
  --
    if rLOC.DISPLAYSEQ is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'DISPLAYSEQ', pnNUM_VALUE => rLOC.DISPLAYSEQ);
    end if;
  --
    if rLOC.RSKEY is not null
    then P_LOCATION.INSERT_LOCATION_ATTRIBUTE(nLOC_ID, 'RSKEY', rLOC.RSKEY);
    end if;
  --
    if rLOC.NOTES is not null
    then
      nTXT_SEQ_NBR := null;
      P_LOCATION.SET_LOC_TEXT(nLOC_ID, nLOC_VERSION_NBR, 'NOTE', nTXT_SEQ_NBR, 'en', rLOC.NOTES);
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' LOCATIONS records inserted');
--
  iCount := 0;
--
  for rLOC in
   (select KEY, UNSD_FROM_KEY, UNSDA_FROM_KEY, HCRRESP_FROM_KEY, RSGEO_FROM_KEY, RSHCR_FROM_KEY
    from STAGE.S_LOCATIONS_REGIONS
    order by KEY)
  loop
    if rLOC.UNSD_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.UNSD_FROM_KEY), anLOC_ID(rLOC.KEY), 'UNSD');
    end if;
  --
    if rLOC.UNSDA_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.UNSDA_FROM_KEY), anLOC_ID(rLOC.KEY), 'UNSDA');
    end if;
  --
    if rLOC.HCRRESP_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.HCRRESP_FROM_KEY), anLOC_ID(rLOC.KEY), 'HCRRESP');
    end if;
  --
    if rLOC.RSGEO_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.RSGEO_FROM_KEY), anLOC_ID(rLOC.KEY), 'RSGEO');
    end if;
  --
    if rLOC.RSHCR_FROM_KEY is not null
    then
      iCount := iCount + 1;
      P_LOCATION.INSERT_LOCATION_RELATIONSHIP(anLOC_ID(rLOC.RSHCR_FROM_KEY), anLOC_ID(rLOC.KEY), 'RSHCR');
    end if;
  end loop;
--
  dbms_output.put_line(to_char(iCount) || ' LOCATION_RELATIONSHIPS records inserted');
end;
/
