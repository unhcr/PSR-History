@dropall
@drop

spool Rebuild.log

purge recyclebin;

prompt Schema
prompt ======
@Schema

prompt Views
prompt =====
@Views

prompt Packages
prompt ========
@Packages

prompt Triggers
prompt ========
@Triggers

prompt InitBase
prompt ========
@InitBase

prompt LoadLanguages
prompt =============
@LoadLanguages

prompt LoadTextTypes
prompt =============
@LoadTextTypes

prompt LoadMessages
prompt ============
@LoadMessages

prompt InitParameters
prompt ==============
@InitParameters

prompt LoadDisplacementStatuses
prompt ========================
@LoadDisplacementStatuses

prompt InitSexes
prompt =========
@InitSexes

prompt InitAgeProfiles
prompt ===============
@InitAgeProfiles

prompt LoadDimensionTypes
prompt ==================
@LoadDimensionTypes

prompt LoadStatisticTypes
prompt ==================
@LoadStatisticTypes

prompt LoadStatisticGroupAttributeTypes
prompt =================================
@LoadStatisticGroupAttributeTypes

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

prompt LoadLocationTypeVariants
prompt ========================
@LoadLocationTypeVariants

prompt LoadLocationsSubdivisions
prompt =========================
@LoadLocationsSubdivisions

prompt LoadPPGs
prompt ========
@LoadPPGs

prompt LoadStatistics
prompt ==============
@LoadStatistics

prompt DeactivateCodes
prompt ===============
@DeactivateCodes

--prompt InitTests
--prompt =========
--@InitTests

commit;

--execute dbms_stats.gather_schema_stats(user);

spool off
