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

prompt LoadLanguages
prompt =============
@LoadLanguages

prompt LoadStatisticTypes
prompt =============
@LoadStatisticTypes

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

prompt LoadDimensionTypes
prompt ==================
@LoadDimensionTypes

prompt LoadLocationTypes
prompt =================
@LoadLocationTypes

prompt LoadLocationAttributeTypes
prompt ==========================
@LoadLocationAttributeTypes

prompt LoadLocationRelationshipTypes
prompt =============================
@LoadLocationRelationshipTypes

prompt LoadLocationsRegions
prompt ====================
@LoadLocationsRegions

prompt LoadLocationsCountries
prompt ======================
@LoadLocationsCountries

--prompt LoadLocations_Subdivisions
--prompt ==========================
--@LoadLocations_Subdivisions

--prompt LoadPPGs
--prompt ========
--@LoadPPGs

prompt LoadStatistics
prompt ==============
@LoadStatistics

--prompt InitTests
--prompt =========
--@InitTests

commit;

--execute dbms_stats.gather_schema_stats(user);

spool off
