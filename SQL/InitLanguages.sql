declare
  nVERSION_NBR LOCATION.tnLOC_VERSION_NBR;
  nSEQ_NBR LOCATION.tnTXI_SEQ_NBR;
begin
  for rLANG in
   (select CODE, ENGLISH_NAME, FRENCH_NAME
    from STAGE.LANGUAGES
    where CODE not in
     (select CODE from LANGUAGES)
    order by CODE)
  loop
    LANGUAGE.INSERT_LANGUAGE(rLANG.CODE, 'en', rLANG.ENGLISH_NAME);
    nVERSION_NBR := 1;
    LANGUAGE.SET_LANG_DESCRIPTION(rLANG.CODE, nVERSION_NBR, 'fr', rLANG.FRENCH_NAME);
  end loop;
end;
/
