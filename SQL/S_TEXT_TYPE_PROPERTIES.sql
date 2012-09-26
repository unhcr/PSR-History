create table S_TEXT_TYPE_PROPERTIES 
 (TXTT_CODE varchar2(10),
  TAB_ALIAS varchar2(10),
  MANDATORY_FLAG varchar2(1),
  MULTI_INSTANCE_FLAG varchar2(1),
  LONG_TEXT_FLAG varchar2(1),
  NOTES varchar2(4000))
organization external
 (type oracle_loader
  default directory PSRDATA
  access parameters 
   (records delimited by newline
    characterset UTF16
    badfile 'TEXT_TYPE_PROPERTIES.bad'
    nodiscardfile
    nologfile
    skip 1 
    fields terminated by x'0009'
    lrtrim
    missing field values are null
    reject rows with all null fields
     (TXTT_CODE char(4000),
      TAB_ALIAS char(4000),
      MANDATORY_FLAG char(4000),
      MULTI_INSTANCE_FLAG char(4000),
      LONG_TEXT_FLAG char(4000),
      NOTES char(4000)))
  location ('TEXT_TYPE_PROPERTIES.tsv'))
reject limit unlimited;

grant select on S_TEXT_TYPE_PROPERTIES to PSR_STAGE;
