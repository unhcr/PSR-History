create table S_STATISTIC_TYPES 
 (CODE varchar2(10),
  DESCRIPTION_EN varchar2(1000),
  DISPLAY_SEQ number(5),
  DESCRIPTION_FR varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile PSRDATA:'STATISTIC_TYPES.bad'
    nodiscardfile
    nologfile
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      DESCRIPTION_EN char(4000),
      DISPLAY_SEQ char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('STATISTIC_TYPES.csv'))
reject limit unlimited;
  
grant select on S_STATISTIC_TYPES to PSR_STAGE;
