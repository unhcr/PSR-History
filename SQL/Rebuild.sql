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

commit;

spool off
