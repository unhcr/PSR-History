create table S_ASR_T2_2010 
 (TABLE_NUMBER varchar2(5),
  STATSYEAR varchar2(4),
  COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  DISPLACEMENT_STATUS varchar2(8),
  POP_START integer,
  POP_AH_START integer,
  ARR_GRP integer,
  ARR_IND integer,
  ARR_RESTL integer,
  BIRTH integer,
  REFOTHINC integer,
  TOTAL_INCREASE integer,
  VOLREP integer,
  VOLREP_AH integer,
  RESTL integer,
  RESTL_AH integer,
  CESSATION integer,
  NATURLZN integer,
  DEATH integer,
  REFOTHDEC integer,
  TOTAL_DECREASE integer,
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
    badfile 'ASR_T2_2010.bad'
    nodiscardfile
    nologfile
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
      COU_CODE_ORIGIN char(4000),
      DISPLACEMENT_STATUS char(4000),
      POP_START char(4000),
      POP_AH_START char(4000),
      ARR_GRP char(4000),
      ARR_IND char(4000),
      ARR_RESTL char(4000),
      BIRTH char(4000),
      REFOTHINC char(4000),
      TOTAL_INCREASE char(4000),
      VOLREP char(4000),
      VOLREP_AH char(4000),
      RESTL char(4000),
      RESTL_AH char(4000),
      CESSATION char(4000),
      NATURLZN char(4000),
      DEATH char(4000),
      REFOTHDEC char(4000),
      TOTAL_DECREASE char(4000),
      POP_END char(4000),
      POP_AH_END char(4000),
      SOURCE char(4000),
      BASIS char(4000))
    column transforms
     (TABLE_NUMBER from constant '2',
      STATSYEAR from constant '2010'))
  location ('ASR_T2_REF_2010.csv', 'ASR_T2_REFLIKE_2010.csv'))
reject limit unlimited;

grant select on S_ASR_T2_2010 to PSR_STAGE;
