declare
  nROL_ID P_BASE.tnROL_ID;
begin
  select ID into nROL_ID from ROLES where DESCRIPTION = 'Public query';
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_ENGLISH', 'en', 'Public user - English language');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_ENGLISH', 'en', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('PUBLIC_ENGLISH', nROL_ID);
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_FRENCH', 'en', 'Public user - French language');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_FRENCH', 'fr', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('PUBLIC_FRENCH', nROL_ID);
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_SPANISH', 'en', 'Public user - Spanish language');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_SPANISH', 'es', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('PUBLIC_SPANISH', nROL_ID);
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_RUSSIAN', 'en', 'Public user - Russian language');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_RUSSIAN', 'ru', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('PUBLIC_RUSSIAN', nROL_ID);
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_ARABIC', 'en', 'Public user - Arabic language');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_ARABIC', 'ar', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('PUBLIC_ARABIC', nROL_ID);
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_CHINESE', 'en', 'Public user - Chinese language');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_CHINESE', 'zh', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('PUBLIC_CHINESE', nROL_ID);
--
  select ID into nROL_ID from ROLES where DESCRIPTION = 'Administrator';
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('ADMIN', 'en', 'PSR administrator');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('ADMIN', 'en', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('ADMIN', nROL_ID);
--
  select ID into nROL_ID from ROLES where DESCRIPTION = 'ASR statistics unit review';
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('STAT1', 'en', 'ASR statistics unit user 1');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('STAT1', 'en', 1);
  P_SYSTEM_USER.INSERT_USER_ROLE('STAT1', nROL_ID);
--
  select ID into nROL_ID from ROLES where DESCRIPTION = 'ASR data entry';
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('DE1', 'en', 'ASR data entry user 1');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('DE1', 'en', 1);
  for rCOU in
   (select ID
    from COUNTRIES
    where ISO3166_ALPHA3_CODE = 'ZMB'
    and START_DATE <= sysdate
    and END_DATE > sysdate)
  loop
    P_SYSTEM_USER.INSERT_USER_ROLE('DE1', nROL_ID, rCOU.ID);
  end loop;
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('DE2', 'en', 'ASR data entry user 2');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('DE2', 'fr', 1);
  for rCOU in
   (select ID
    from COUNTRIES
    where ISO3166_ALPHA3_CODE in ('AFG', 'PAK')
    and START_DATE <= sysdate
    and END_DATE > sysdate)
  loop
    P_SYSTEM_USER.INSERT_USER_ROLE('DE2', nROL_ID, rCOU.ID);
  end loop;
--
  select ID into nROL_ID from ROLES where DESCRIPTION = 'ASR bureau review';
--
  P_SYSTEM_USER.INSERT_SYSTEM_USER('BUR1', 'en', 'ASR bureau user 1');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('BUR1', 'en', 1);
  for rCOU in
   (select ID
    from COUNTRIES
    where ISO3166_ALPHA3_CODE in ('TCD','DJI','ERI','ETH','KEN','SOM','SSD','SDN','UGA')
    and START_DATE <= sysdate
    and END_DATE > sysdate)
  loop
    P_SYSTEM_USER.INSERT_USER_ROLE('BUR1', nROL_ID, rCOU.ID);
  end loop;
end;
/
