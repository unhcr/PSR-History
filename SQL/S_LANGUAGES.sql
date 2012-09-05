create table S_LANGUAGES
 (CODE varchar2(2),
  NAME_EN varchar2(100),
  DISPLAY_SEQ number(5),
  ACTIVE_FLAG varchar2(1),
  NAME_FR varchar2(100))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile 'LANGUAGES.bad'
    nodiscardfile
    nologfile
    skip 1
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      NAME_EN char(4000),
      DISPLAY_SEQ char(4000),
      ACTIVE_FLAG char(4000),
      NAME_FR char(4000)))
  location ('LANGUAGES.csv'))
reject limit unlimited;

grant select on S_LANGUAGES to PSR_STAGE;
