-- Table aliases
-- =============

insert into T_TABLE_ALIASES (ALIAS, TABLE_NAME)
select substr(CONSTRAINT_NAME, 4), TABLE_NAME
from USER_CONSTRAINTS
where CONSTRAINT_TYPE = 'P'
and GENERATED = 'USER NAME';


-- Initial "bootstrapping" entries in text-related tables
-- ======================================================

variable ITM_ID number;
insert into T_DATA_ITEMS (ID, TAB_ALIAS) values (ITM_SEQ.nextval, 'TXTT') returning ID into :ITM_ID;
insert into T_TEXT_TYPES (CODE, ITM_ID) values ('DESCR', ITM_SEQ.currval);
insert into T_TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG) values ('DESCR', 'TXTT', 'Y', 'N', 'N');
insert into T_TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG) values ('DESCR', 'LANG', 'Y', 'N', 'N');
insert into T_TEXT_TYPE_HEADERS (ITM_ID, TXTT_CODE, TAB_ALIAS, TXT_SEQ_NBR_MAX) values (ITM_SEQ.currval, 'DESCR', 'TXTT', 1);
insert into T_DATA_ITEMS (ID, TAB_ALIAS) values (ITM_SEQ.nextval, 'LANG');
insert into T_TEXT_TYPE_HEADERS (ITM_ID, TXTT_CODE, TAB_ALIAS, TXT_SEQ_NBR_MAX) values (ITM_SEQ.currval, 'DESCR', 'LANG', 1);
insert into T_LANGUAGES (CODE, DISPLAY_SEQ, ITM_ID) values ('en', 1, ITM_SEQ.currval);
insert into T_TEXT_ITEMS (ITM_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT) values (:ITM_ID, 'DESCR', 1, 'en', 'TXTT', 'Description');
insert into T_TEXT_ITEMS (ITM_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT) values (ITM_SEQ.currval, 'DESCR', 1, 'en', 'LANG', 'English');


-- Languages
-- =========

-- All the UN languages
execute P_LANGUAGE.INSERT_LANGUAGE('fr', 'en', 'French', 2);
execute P_LANGUAGE.INSERT_LANGUAGE('es', 'en', 'Spanish');
execute P_LANGUAGE.INSERT_LANGUAGE('ru', 'en', 'Russian');
execute P_LANGUAGE.INSERT_LANGUAGE('ar', 'en', 'Arabic');
execute P_LANGUAGE.INSERT_LANGUAGE('zh', 'en', 'Chinese');

-- Descriptions in all the UN languages

variable VERSION_NBR number;
execute :VERSION_NBR := 1; P_LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'fr', unistr('Anglais'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'es', unistr('Ingl\00E9s'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'ru', unistr('\0430\043D\0433\043B\0438\0439\0441\043A\0438\0439'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'ar', unistr('\0627\0644\0625\0646\062C\0644\064A\0632\064A\0629'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'zh', unistr('\82F1\8BED'));

execute :VERSION_NBR := 1; P_LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'fr', unistr('Fran\00E7ais'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'es', unistr('Franc\00E9s'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'ru', unistr('\0444\0440\0430\043D\0446\0443\0437\0441\043A\0438\0439'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'ar', unistr('\0627\0644\0641\0631\0646\0633\064A\0629'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'zh', unistr('\6CD5\56FD'));

execute :VERSION_NBR := 1; P_LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'fr', unistr('Espagnol'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'es', unistr('Espa\00F1ol'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'ru', unistr('\0438\0441\043F\0430\043D\0441\043A\0438\0439'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'ar', unistr('\0627\0644\0623\0633\0628\0627\0646\064A\0629'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'zh', unistr('\897F\73ED\7259'));

execute :VERSION_NBR := 1; P_LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'fr', unistr('Russe'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'es', unistr('Ruso'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'ru', unistr('\0440\0443\0441\0441\043A\0438\0439'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'ar', unistr('\0627\0644\0631\0648\0633\064A\0629'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'zh', unistr('\4FC4\7F57\65AF'));

execute :VERSION_NBR := 1; P_LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'fr', unistr('Arabe'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'es', unistr('\00C1rabe'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'ru', unistr('\0430\0440\0430\0431\0441\043A\0438\0439'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'ar', unistr('\0627\0644\0639\0631\0628\064A\0629'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'zh', unistr('\963F\62C9\4F2F\8BED'));

execute :VERSION_NBR := 1; P_LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'fr', unistr('Chinois'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'es', unistr('Chino'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'ru', unistr('\043A\0438\0442\0430\0439\0441\043A\0438\0439'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'ar', unistr('\0627\0644\0635\064A\0646\064A\0629'));
execute P_LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'zh', unistr('\4E2D\56FD'));

-- Inactive language for testing (English description only)

execute P_LANGUAGE.INSERT_LANGUAGE('la', 'en', 'Latin (inactive language for testing)', psACTIVE_FLAG => 'N');


-- Text types with descriptions in all UN languages and text type properties
-- =========================================================================

-- Description descriptions and description text type properties

execute :VERSION_NBR := 1; P_TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'fr', unistr('Description'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'es', unistr('Descripci\00F3n'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'ru', unistr('\043E\043F\0438\0441\0430\043D\0438\0435'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'ar', unistr('\0648\0635\0641'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'zh', unistr('\8BF4\660E'));

execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'AGP');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'AGR');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'COMP');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'DIM');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'DIMT');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'DST');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCT');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCAT');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCRT');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCTV');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'PERT');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'PPG');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'SEX');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'STCG');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'STCT');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'SYP');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'UATT');

-- Messages, message descriptions, and message text type properties

execute P_TEXT_TYPE.INSERT_TEXT_TYPE('MSG', 'en', 'Message');
execute :VERSION_NBR := 1; P_TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'fr', unistr('Message'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'es', unistr('Mensaje'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'ru', unistr('\0441\043E\043E\0431\0449\0435\043D\0438\0435'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'ar', unistr('\0631\0633\0627\0644\0629'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'zh', unistr('\6D88\606F'));

execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('MSG', 'MSG');

-- Notes, note descriptions, and note text type properties

execute P_TEXT_TYPE.INSERT_TEXT_TYPE('NOTE', 'en', 'Note');
execute :VERSION_NBR := 1; P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'fr', unistr('Remarque'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'es', unistr('Nota'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'ru', unistr('\043F\0440\0438\043C\0435\0447\0430\043D\0438\0435'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'ar', unistr('\0645\0630\0643\0631\0629'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'zh', unistr('\8BF7\6CE8\610F'));

execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'AGP', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'AGR', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'COMP', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'DIM', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'DIMT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'DST', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LANG', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOC', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCA', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCAT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCR', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCRT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCTR', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCTV', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'MSG', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'PER', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'PERT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'PPG', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'SEX', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'STC', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'STCG', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'STCT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'STCTG', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'SYP', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'TAB', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'TTP', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'TXTT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'UAT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'UATT', 'N', 'Y', 'Y');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'USR', 'N', 'Y', 'Y');

-- Names, name descriptions, and name text type properties

execute P_TEXT_TYPE.INSERT_TEXT_TYPE('NAME', 'en', 'Name');
execute :VERSION_NBR := 1; P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'fr', unistr('Nom'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'es', unistr('Nombre'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'ru', unistr('\0438\043C\044F'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'ar', unistr('\0627\0633\0645'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'zh', unistr('\540D\79F0'));

execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NAME', 'USR');
execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NAME', 'LOC');

-- Formal names, formal name descriptions, and formal name text type properties for locations

execute P_TEXT_TYPE.INSERT_TEXT_TYPE('FORMALNAME', 'en', 'Formal name');
execute :VERSION_NBR := 1; P_TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'fr', unistr('Nom officiel'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'es', unistr('Nombre formal'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'ru', unistr('\041E\0444\0438\0446\0438\0430\043B\044C\043D\043E\0435 \043D\0430\0437\0432\0430\043D\0438\0435'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'ar', unistr('\0627\0633\0645 \0631\0633\0645\064A'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'zh', unistr('\6B63\5F0F\540D\79F0'));

execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('FORMALNAME', 'LOC');

-- Alternative names, alternative name descriptions, and alternative name text type properties for locations

execute P_TEXT_TYPE.INSERT_TEXT_TYPE('ALTNAME', 'en', 'Alternative name');
execute :VERSION_NBR := 1; P_TEXT_TYPE.SET_TXTT_DESCRIPTION('ALTNAME', :VERSION_NBR, 'fr', unistr('Autre nom'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('ALTNAME', :VERSION_NBR, 'es', unistr('Nombre alternativo'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('ALTNAME', :VERSION_NBR, 'ru', unistr('\0430\043B\044C\0442\0435\0440\043D\0430\0442\0438\0432\043D\043E\0435 \043D\0430\0437\0432\0430\043D\0438\0435'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('ALTNAME', :VERSION_NBR, 'ar', unistr('\0627\0633\0645 \0628\062F\064A\0644'));
execute P_TEXT_TYPE.SET_TXTT_DESCRIPTION('ALTNAME', :VERSION_NBR, 'zh', unistr('\66FF\4EE3\540D\79F0'));

execute P_TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('ALTNAME', 'LOC');
