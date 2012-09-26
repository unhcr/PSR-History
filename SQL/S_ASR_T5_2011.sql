create table S_ASR_T5_2011 
 (TABLE_NUMBER varchar2(5),
  STATSYEAR varchar2(4),
  DST_CODE varchar2(3),
  COU_CODE_ASYLUM varchar2(3),
  DIM_RSDTYPE_VALUE varchar2(1),
  PROCEDURE_LEVEL varchar2(3),
  APPLICATION_IND_GROUP varchar2(1),
  APPLICATION_GROUP_SIZE varchar2(5),
  DIM_RSDLEVEL_VALUE varchar2(2),
  DECISION_IND_GROUP varchar2(1),
  DECISION_GROUP_SIZE varchar2(5),
  COU_CODE_ORIGIN varchar2(3),
  ASY_START integer,
  ASY_AH_START integer,
  ASYAPP integer,
  ASYREC_CV integer,
  ASYREC_CP integer,
  ASYREJ integer,
  ASYOTHCL integer,
  TOTAL_DECISIONS integer,
  ASY_END integer,
  ASY_AH_END integer)
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline 
    characterset WE8MSWIN1252
    badfile 'ASR_T5_2011.bad'
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
      DIM_RSDTYPE_VALUE char(4000),
      PROCEDURE_LEVEL char(4000),
      APPLICATION_IND_GROUP char(4000),
      APPLICATION_GROUP_SIZE char(4000),
      DIM_RSDLEVEL_VALUE char(4000),
      DECISION_IND_GROUP char(4000),
      DECISION_GROUP_SIZE char(4000),
      COU_CODE_ORIGIN char(4000),
      ASY_START char(4000),
      ASY_AH_START char(4000),
      ASYAPP char(4000),
      ASYREC_CV char(4000),
      ASYREC_CP char(4000),
      ASYREJ char(4000),
      ASYOTHCL char(4000),
      TOTAL_DECISIONS char(4000),
      ASY_END char(4000),
      ASY_AH_END char(4000))
    column transforms
     (TABLE_NUMBER from constant '5',
      STATSYEAR from constant '2011',
      DST_CODE from constant 'ASY'))
  location ('ASR_T5_2011.csv'))
reject limit unlimited;

grant select on S_ASR_T5_2011 to PSR_STAGE;
