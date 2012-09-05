create table S_ASR_T7B_2011 
 (COU_CODE_ASYLUM varchar2(3),
  COU_CODE_ORIGIN varchar2(3),
  RETURN integer,
  RETURN_AH integer,
  SOURCE varchar2(2),
  BASIS varchar2(1))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile 'ASR_T7B_2011.bad'
    nodiscardfile
    nologfile
    skip 0 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
    reject rows with all null fields
     (FILLER1 char(4000),
      COU_CODE_ASYLUM char(4000),
      COU_CODE_ORIGIN char(4000),
      RETURN char(4000),
      RETURN_AH char(4000),
      SOURCE char(4000),
      BASIS char(4000)))
  location ('ASR_T7B_2011.csv'))
reject limit unlimited;
  
grant select on S_ASR_T7B_2011 to PSR_STAGE;
