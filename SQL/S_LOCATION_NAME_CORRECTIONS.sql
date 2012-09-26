create table S_LOCATION_NAME_CORRECTIONS 
 (COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  CORRECTED_LOCATION_NAME varchar2(1000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile 'LOCATIONS_NAME_CORRECTIONS.bad'
    nodiscardfile
    nologfile
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
    reject rows with all null fields
     (COU_CODE_ASYLUM char(4000),
      LOCATION_NAME char(4000),
      NEW_LOCATION_NAME char(4000),
      CORRECTED_LOCATION_NAME char(4000)))
  location ('LOCATIONS_NAME_CORRECTIONS.csv'))
reject limit unlimited;

grant select on S_LOCATION_NAME_CORRECTIONS to PSR_STAGE;
