declare
  nVERSION_NBR P_BASE.tnLANG_VERSION_NBR;
  nSEQ_NBR P_BASE.tnTXI_SEQ_NBR;
begin
  for rLANG in
   (select CODE, ENGLISH_NAME, FRENCH_NAME
    from STAGE.LANGUAGES
    where CODE not in
     (select CODE from LANGUAGES)
    order by CODE)
  loop
    P_LANGUAGE.INSERT_LANGUAGE(rLANG.CODE, 'en', rLANG.ENGLISH_NAME);
    nVERSION_NBR := 1;
    P_LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'fr', rLANG.FRENCH_NAME);
  end loop;
end;
/
