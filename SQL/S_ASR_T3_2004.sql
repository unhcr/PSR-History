create table S_ASR_T3_2004
 (TABLE_NUMBER varchar2(5),
  STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  LOCATION_NAME varchar2(1000),
  NEW_LOCATION_NAME varchar2(1000),
  URBAN_RURAL_STATUS varchar2(1),
  ACCOMMODATION_TYPE varchar2(100),
  DISPLACEMENT_STATUS varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  PPG_NAME varchar2(1000),
  F0_4 integer,
  F5_11 integer,
  F12_17 integer,
  F18_59 integer,
  F60 integer,
  FOTHER integer,
  FTOTAL integer,
  M0_4 integer,
  M5_11 integer,
  M12_17 integer,
  M18_59 integer,
  M60 integer,
  MOTHER integer,
  MTOTAL integer,
  TOTAL integer,
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset we8mswin1252
    badfile 'ASR_T3_2004.bad'
    nodiscardfile
    nologfile
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      FILLER3 char(4000),
      FILLER4 char(4000),
      FILLER5 char(4000),
      COU_CODE_ASYLUM char(4000),
      URBAN_RURAL_STATUS char(4000),
      LOCATION_NAME char(4000),
      DISPLACEMENT_STATUS char(4000),
      COU_CODE_ORIGIN char(4000),
      F0_4 char(4000),
      F5_11 char(4000),
      F18_59 char(4000),
      F60 char(4000),
      FOTHER char(4000),
      FTOTAL char(4000),
      M0_4 char(4000),
      M5_11 char(4000),
      M18_59 char(4000),
      M60 char(4000),
      MOTHER char(4000),
      MTOTAL char(4000),
      TOTAL char(4000),
      BASIS char(4000))
    column transforms
     (TABLE_NUMBER from constant '3',
      STATSYEAR from constant '2004',
      NEW_LOCATION_NAME from null,
      ACCOMMODATION_TYPE from null,
      PPG_NAME from null,
      F12_17 from null,
      M12_17 from null))
  location ('ASR_T3_2004.csv'))
reject limit unlimited;
  
grant select on S_ASR_T3_2004 to PSR_STAGE;
