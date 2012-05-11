@dropall
@drop

spool Rebuild.log

purge recyclebin;

prompt PSRD
prompt ====
@PSRD
prompt Packages
prompt ========
@Packages
prompt Triggers
prompt ========
@Triggers
prompt Views
prompt =====
@Views
prompt InitBase
prompt ========
@InitBase
prompt InitMessages
prompt ============
@InitMessages
prompt InitParameters
prompt ==============
@InitParameters
prompt InitLanguages
prompt =============
@InitLanguages
prompt InitStatisticTypes
prompt =============
@InitStatisticTypes
prompt InitDisplacementStatuses
prompt ===========
@InitDisplacementStatuses
prompt InitSexes
prompt =========
@InitSexes
prompt InitAgeProfiles
prompt ===============
@InitAgeProfiles
prompt InitTimePeriods
prompt ===============
@InitTimePeriods
prompt InitDimensions
prompt ==============
@InitDimensions
prompt InitLocations
prompt =============
@InitLocations
prompt InitStatistics
prompt ==============
@InitStatistics

commit;

execute dbms_stats.gather_schema_stats(user);

spool off
