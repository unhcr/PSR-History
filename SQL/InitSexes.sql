variable TXT_ID number;
variable TXI_SEQ_NBR number;

execute :TXT_ID := null; :TXI_SEQ_NBR := null; P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'en', 'Female');
insert into SEXES (CODE, DISPLAY_SEQ, TXT_ID) values ('F', 1, :TXT_ID);
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'fr', 'femelle');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'es', 'femenino');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'ru', '\0436\0435\043D\0449\0438\043D\0430');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'ar', '\0623\0646\062B\0649');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'zh', '\5973');

execute :TXT_ID := null; :TXI_SEQ_NBR := null; P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'en', 'Male');
insert into SEXES (CODE, DISPLAY_SEQ, TXT_ID) values ('M', 2, :TXT_ID);
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'fr', 'm\00E2le');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'es', 'masculino');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'ru', '\043C\0443\0436\0447\0438\043D\0430');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'ar', '\0630\0643\0631');
execute P_TEXT.SET_TEXT(:TXT_ID, 'SEX', 'DESCR', :TXI_SEQ_NBR, 'zh', '\7537');
