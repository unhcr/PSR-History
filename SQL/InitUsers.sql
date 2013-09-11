-- Public pseudo-users for each of the UN languages.
begin
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_ENGLISH', 'en', 'Public user - English language', 'Y', 'Y');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_ENGLISH', 'en', 1);
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_FRENCH', 'en', 'Public user - French language', 'Y', 'Y');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_FRENCH', 'fr', 1);
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_SPANISH', 'en', 'Public user - Spanish language', 'Y', 'Y');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_SPANISH', 'es', 1);
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_RUSSIAN', 'en', 'Public user - Russian language', 'Y', 'Y');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_RUSSIAN', 'ru', 1);
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_ARABIC', 'en', 'Public user - Arabic language', 'Y', 'Y');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_ARABIC', 'ar', 1);
  P_SYSTEM_USER.INSERT_SYSTEM_USER('PUBLIC_CHINESE', 'en', 'Public user - Chinese language', 'Y', 'Y');
  P_SYSTEM_USER.INSERT_USER_LANG_PREFERENCE('PUBLIC_CHINESE', 'zh', 1);
end;
/
