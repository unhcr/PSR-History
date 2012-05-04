variable ITM_ID number;
variable TXT_SEQ_NBR number;

execute :ITM_ID := null; :TXT_SEQ_NBR := null; P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'en', 'Female');
insert into T_SEXES (CODE, DISPLAY_SEQ, ITM_ID) values ('F', 1, :ITM_ID);
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'fr', 'femelle');
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'es', 'femenino');
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'ru', unistr('\0436\0435\043D\0449\0438\043D\0430'));
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'ar', unistr('\0623\0646\062B\0649'));
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'zh', unistr('\5973'));

execute :ITM_ID := null; :TXT_SEQ_NBR := null; P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'en', 'Male');
insert into T_SEXES (CODE, DISPLAY_SEQ, ITM_ID) values ('M', 2, :ITM_ID);
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'fr', unistr('m\00E2le'));
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'es', 'masculino');
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'ru', unistr('\043C\0443\0436\0447\0438\043D\0430'));
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'ar', unistr('\0630\0643\0631'));
execute P_TEXT.SET_TEXT(:ITM_ID, 'SEX', 'DESCR', :TXT_SEQ_NBR, 'zh', unistr('\7537'));
