@dropall
@drop

spool Rebuild.log

purge recyclebin;

@PSRD
@Packages
@Triggers
@Views
@InitBase
@InitMessages
@InitParameters
@InitLanguages
@InitLocations
@InitStatTypes
@InitPopCats
@InitSexes
@InitAgeProfiles
@InitTimePeriods
@InitDimensions
@InitStatistics

commit;

execute dbms_stats.gather_schema_stats(user);

spool off
