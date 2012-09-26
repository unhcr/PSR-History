create table S_ASR_T7C_2004_2011 
 (TABLE_NUMBER varchar2(5),
  STATSYEAR varchar2(4),
  DST_CODE varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DESCRIPTION varchar2(1000),
  POP_START integer,
  POP_AH_START integer,
  NATLOSS integer,
  STAOTHINC integer,
  NATACQ integer,
  STAOTHDEC integer,
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
    badfile 'ASR_T7C_2004_2011.bad'
    nodiscardfile
    nologfile
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (FILLER1 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      DESCRIPTION char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      NATLOSS char(4000),
      STAOTHINC char(4000),
      NATACQ char(4000),
      STAOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (TABLE_NUMBER from constant '7C',
      DST_CODE from constant 'STA'))
  location ('ASR_T7C_2004_2011.csv'))
reject limit unlimited;

grant select on S_ASR_T7C_2004_2011 to PSR_STAGE;
