@dropall
@drop

spool Rebuild.log

purge recyclebin;

@PSRD
@Packages
@Triggers
@InitBase
@InitMessages
@InitLanguages
@InitLocations

commit;

spool off
