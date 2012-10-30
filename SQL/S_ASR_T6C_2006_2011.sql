create table S_ASR_T6C_2006_2011 
 (TABLE_NUMBER varchar2(5),
  STATSYEAR varchar2(4),
  OFFICIAL varchar2(10),
  COU_CODE_ORIGIN varchar2(3),
  LOCATION_NAME varchar2(1000),
  DST_CODE varchar2(3),
  POP_START integer,
  POP_AH_START integer,
  IDPNEW integer,
  IDPOTHINC integer,
  RETURN integer,
  RETURN_AH integer,
  IDPRELOC integer,
  IDPOTHDEC integer,
  POP_END integer,
  POP_AH_END integer,
  SOURCE varchar2(4),
  BASIS varchar2(5))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile 'ASR_T6C_2006_2011.bad'
    nodiscardfile
    nologfile
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ORIGIN char(4000),
      OFFICIAL char(4000),
      LOCATION_NAME char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      IDPNEW char(4000),
      IDPOTHINC char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      IDPRELOC char(4000),
      IDPOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (TABLE_NUMBER from constant '6C',
      DST_CODE from constant 'IDP'))
  location ('ASR_T6C_2006_2011.csv'))
reject limit unlimited;

grant select on S_ASR_T6C_2006_2011 to PSR_STAGE;
