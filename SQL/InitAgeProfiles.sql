declare
  nAGR_ID P_BASE.tnAGR_ID;
begin
  P_AGE_PROFILE.INSERT_AGE_PROFILE('STD', 'en', 'UNHCR standard age profile');
--
  P_AGE_PROFILE.INSERT_AGE_RANGE(nAGR_ID, 'en', '0-4 years', 'STD', 0, 4);
  P_AGE_PROFILE.INSERT_AGE_RANGE(nAGR_ID, 'en', '5-11 years', 'STD', 5, 11);
  P_AGE_PROFILE.INSERT_AGE_RANGE(nAGR_ID, 'en', '12-17 years', 'STD', 12, 17);
  P_AGE_PROFILE.INSERT_AGE_RANGE(nAGR_ID, 'en', '18-59 years', 'STD', 18, 59);
  P_AGE_PROFILE.INSERT_AGE_RANGE(nAGR_ID, 'en', '60 years or over', 'STD', 60, 999);
end;
/
