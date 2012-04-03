@dropall
@drop

spool Rebuild.log

purge recyclebin;

@PSRD
@Packages
@Triggers
@InitBase
@InitMessages
@InitParameters
@InitLanguages
@InitLocations
@InitPopCats
@InitAgeProfiles
@InitTimePeriods
@InitStatTypes

commit;

execute dbms_stats.gather_schema_stats(user);

spool off
