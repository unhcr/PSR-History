select TXT_ID from AGE_PROFILES where TXT_ID is not null
union all
select TXT_ID from AGE_RANGES where TXT_ID is not null
union all
select TXT_ID from COMPONENTS where TXT_ID is not null
union all
select TXT_ID from LANGUAGES where TXT_ID is not null
union all
select TXT_ID from LOCATIONS where TXT_ID is not null
union all
select TXT_ID from LOCATION_ATTRIBUTES where TXT_ID is not null
union all
select TXT_ID from LOCATION_ATTRIBUTE_TYPES where TXT_ID is not null
union all
select TXT_ID from LOCATION_RELATIONSHIPS where TXT_ID is not null
union all
select TXT_ID from LOCATION_RELATIONSHIP_TYPES where TXT_ID is not null
union all
select TXT_ID from LOCATION_TYPES where TXT_ID is not null
union all
select TXT_ID from MESSAGES where TXT_ID is not null
union all
select TXT_ID from POPULATION_CATEGORIES where TXT_ID is not null
union all
select TXT_ID from POPULATION_PLANNING_GROUPS where TXT_ID is not null
union all
select TXT_ID from STATISTICS where TXT_ID is not null
union all
select TXT_ID from STATISTIC_GROUPS where TXT_ID is not null
union all
select TXT_ID from STATISTIC_TYPES where TXT_ID is not null
union all
select TXT_ID from STATISTIC_TYPES_IN_GROUPS where TXT_ID is not null
union all
select TXT_ID from TABLE_ALIASES where TXT_ID is not null
union all
select TXT_ID from TEXT_TYPES where TXT_ID is not null
union all
select TXT_ID from TEXT_TYPE_PROPERTIES where TXT_ID is not null
union all
select TXT_ID from TIME_PERIODS where TXT_ID is not null
union all
select TXT_ID from TIME_PERIOD_TYPES where TXT_ID is not null
minus
select ID from TEXT_HEADERS
/

