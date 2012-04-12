variable DIM_ID number;

execute P_DIMENSION.INSERT_DIMENSION_TYPE('ACMT', 'en', 'Accommodation type')

execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Camp', 'ACMT', 'CAMP');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Centre', 'ACMT', 'CENTRE');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Dispersed', 'ACMT', 'DISPERSED');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Individual accommodation', 'ACMT', 'INDIVIDUAL');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Settlement', 'ACMT', 'SETTLEMENT');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Undefined', 'ACMT', 'UNDEFINED');

execute P_DIMENSION.INSERT_DIMENSION_TYPE('UR', 'en', 'Urban / Rural')

execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Urban', 'UR', 'U');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Rural', 'UR', 'R');
execute P_DIMENSION.INSERT_DIMENSION_VALUE(:DIM_ID, 'en', 'Other/mixed', 'UR', 'V');
