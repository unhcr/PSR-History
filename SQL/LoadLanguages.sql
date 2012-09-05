declare
  nVERSION_NBR P_BASE.tnLANG_VERSION_NBR;
begin
  for rLANG in
   (select CODE, NAME_EN, DISPLAY_SEQ, ACTIVE_FLAG, NAME_FR
    from STAGE.S_LANGUAGES
    where CODE not in
     (select CODE from T_LANGUAGES)
    order by CODE)
  loop
    P_LANGUAGE.INSERT_LANGUAGE(rLANG.CODE, 'en', rLANG.NAME_EN, rLANG.DISPLAY_SEQ, rLANG.ACTIVE_FLAG);
    nVERSION_NBR := 1;
    P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'fr', rLANG.NAME_FR);
  end loop;
end;
/
