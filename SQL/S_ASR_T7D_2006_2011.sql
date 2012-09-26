create table S_ASR_T7D_2006_2011 
 (STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DESCRIPTION varchar2(1000),
  POP_START integer,
  POP_AH_START integer,
  OOCARR integer,
  OOCOTHINC integer,
  OOCRTN integer,
  OOCOTHDEC integer,
  POP_END integer,
  POP_AH_END integer,
  SOURCE varchar2(3),
  BASIS varchar2(2))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile 'ASR_T7D_2006_2011.bad'
    nodiscardfile
    nologfile
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
    reject rows with all null fields
     (FILLER1 char(4000),
      FILLER2 char(4000),
      STATSYEAR char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      DESCRIPTION char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      OOCARR char(4000),
      OOCOTHINC char(4000),
      OOCRTN char(4000),
      OOCOTHDEC char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000)))
  location ('ASR_T7D_2006_2011.csv'))
reject limit unlimited;

grant select on S_ASR_T7D_2006_2011 to PSR_STAGE;