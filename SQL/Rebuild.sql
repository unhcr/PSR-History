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

commit;

spool off
