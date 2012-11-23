create table S_STC_GROUP_ATTRIBUTE_TYPES 
 (CODE varchar2(10),
  DESCRIPTION_EN varchar2(1000),
  DATA_TYPE varchar2(1),
  DISPLAY_SEQ number(5),
  DESCRIPTION_FR varchar2(1000),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset WE8MSWIN1252
    badfile 'STC_GROUP_ATTRIBUTE_TYPES.bad'
    nodiscardfile
    nologfile
    skip 1 
    fields terminated by ','
    optionally enclosed by '"' and '"'
    lrtrim
    missing field values are null
     (CODE char(4000),
      DESCRIPTION_EN char(4000),
      DATA_TYPE char(4000),
      DISPLAY_SEQ char(4000),
      DESCRIPTION_FR char(4000),
      NOTES char(4000)))
  location ('STC_GROUP_ATTRIBUTE_TYPES.csv'))
reject limit unlimited;
  
grant select on S_STC_GROUP_ATTRIBUTE_TYPES to PSR_STAGE;
