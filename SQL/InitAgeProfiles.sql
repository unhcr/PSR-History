variable AGR_ID number;

execute P_AGE_PROFILE.INSERT_AGE_PROFILE('STD', 'en', 'UNHCR standard age profile');

execute P_AGE_PROFILE.INSERT_AGE_RANGE(:AGR_ID, 'en', '0-4 years', 'STD', 0, 4);
execute P_AGE_PROFILE.INSERT_AGE_RANGE(:AGR_ID, 'en', '5-11 years', 'STD', 5, 11);
execute P_AGE_PROFILE.INSERT_AGE_RANGE(:AGR_ID, 'en', '12-17 years', 'STD', 12, 17);
execute P_AGE_PROFILE.INSERT_AGE_RANGE(:AGR_ID, 'en', '18-59 years', 'STD', 18, 59);
execute P_AGE_PROFILE.INSERT_AGE_RANGE(:AGR_ID, 'en', '60 years or over', 'STD', 60, 999);
