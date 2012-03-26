-- Table aliases
-- =============

insert into TABLE_ALIASES (ALIAS, TABLE_NAME)
select substr(CONSTRAINT_NAME, 4), TABLE_NAME
from USER_CONSTRAINTS
where CONSTRAINT_TYPE = 'P'
and GENERATED = 'USER NAME';


-- Initial "bootstrapping" entries in text-related tables
-- ======================================================

variable TXT_ID number;
insert into TEXT_HEADERS (ID, TAB_ALIAS) values (TXT_SEQ.nextval, 'TXTT') returning ID into :TXT_ID;
insert into TEXT_TYPES (CODE, TXT_ID) values ('DESCR', TXT_SEQ.currval);
insert into TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG) values ('DESCR', 'TXTT', 'Y', 'N', 'N');
insert into TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY_FLAG, MULTI_INSTANCE_FLAG, LONG_TEXT_FLAG) values ('DESCR', 'LANG', 'Y', 'N', 'N');
insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX) values (TXT_SEQ.currval, 'DESCR', 'TXTT', 1);
insert into TEXT_HEADERS (ID, TAB_ALIAS) values (TXT_SEQ.nextval, 'LANG');
insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX) values (TXT_SEQ.currval, 'DESCR', 'LANG', 1);
insert into LANGUAGES (CODE, TXT_ID) values ('en', TXT_SEQ.currval);
insert into TEXT_ITEMS (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT) values (:TXT_ID, 'DESCR', 1, 'en', 'TXTT', 'Description');
insert into TEXT_ITEMS (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS, TEXT) values (TXT_SEQ.currval, 'DESCR', 1, 'en', 'LANG', 'English');


-- Languages
-- =========

-- All the UN languages
execute LANGUAGE.INSERT_LANGUAGE('fr', 'en', 'French');
execute LANGUAGE.INSERT_LANGUAGE('es', 'en', 'Spanish');
execute LANGUAGE.INSERT_LANGUAGE('ru', 'en', 'Russian');
execute LANGUAGE.INSERT_LANGUAGE('ar', 'en', 'Arabic');
execute LANGUAGE.INSERT_LANGUAGE('zh', 'en', 'Chinese');

-- Descriptions in all the UN languages

variable VERSION_NBR number;
execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'fr', unistr('Anglais'));
execute LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'es', unistr('Ingl\00E9s'));
execute LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'ru', unistr('\0430\043D\0433\043B\0438\0439\0441\043A\0438\0439'));
execute LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'ar', unistr('\0627\0644\0625\0646\062C\0644\064A\0632\064A\0629'));
execute LANGUAGE.SET_LANG_DESCRIPTION('en', :VERSION_NBR, 'zh', unistr('\82F1\8BED'));

execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'fr', unistr('Fran\00E7ais'));
execute LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'es', unistr('Franc\00E9s'));
execute LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'ru', unistr('\0444\0440\0430\043D\0446\0443\0437\0441\043A\0438\0439'));
execute LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'ar', unistr('\0627\0644\0641\0631\0646\0633\064A\0629'));
execute LANGUAGE.SET_LANG_DESCRIPTION('fr', :VERSION_NBR, 'zh', unistr('\6CD5\56FD'));

execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'fr', unistr('Espagnol'));
execute LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'es', unistr('Espa\00F1ol'));
execute LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'ru', unistr('\0438\0441\043F\0430\043D\0441\043A\0438\0439'));
execute LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'ar', unistr('\0627\0644\0623\0633\0628\0627\0646\064A\0629'));
execute LANGUAGE.SET_LANG_DESCRIPTION('es', :VERSION_NBR, 'zh', unistr('\897F\73ED\7259'));

execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'fr', unistr('Russe'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'es', unistr('Ruso'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'ru', unistr('\0440\0443\0441\0441\043A\0438\0439'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'ar', unistr('\0627\0644\0631\0648\0633\064A\0629'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ru', :VERSION_NBR, 'zh', unistr('\4FC4\7F57\65AF'));

execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'fr', unistr('Arabe'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'es', unistr('\00C1rabe'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'ru', unistr('\0430\0440\0430\0431\0441\043A\0438\0439'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'ar', unistr('\0627\0644\0639\0631\0628\064A\0629'));
execute LANGUAGE.SET_LANG_DESCRIPTION('ar', :VERSION_NBR, 'zh', unistr('\963F\62C9\4F2F\8BED'));

execute :VERSION_NBR := 1; LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'fr', unistr('Chinois'));
execute LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'es', unistr('Chino'));
execute LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'ru', unistr('\043A\0438\0442\0430\0439\0441\043A\0438\0439'));
execute LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'ar', unistr('\0627\0644\0635\064A\0646\064A\0629'));
execute LANGUAGE.SET_LANG_DESCRIPTION('zh', :VERSION_NBR, 'zh', unistr('\4E2D\56FD'));

-- Inactive language for testing (English description only)

execute LANGUAGE.INSERT_LANGUAGE('la', 'en', 'Latin (inactive language for testing)', psACTIVE_FLAG => 'N');


-- Text types with descriptions in all UN languages and text type properties
-- =========================================================================

-- Description text type properties and description descriptions

execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'COMP');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'UATT');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCT');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCAT');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('DESCR', 'LOCRT');

execute :VERSION_NBR := 1; TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'fr', unistr('Description'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'es', unistr('Descripci\00F3n'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'ru', unistr('\043E\043F\0438\0441\0430\043D\0438\0435'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'ar', unistr('\0648\0635\0641'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('DESCR', :VERSION_NBR, 'zh', unistr('\8BF4\660E'));

-- Messages, message text type properties, and message descriptions

execute TEXT_TYPE.INSERT_TEXT_TYPE('MSG', 'en', 'Message');

execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('MSG', 'MSG');

execute :VERSION_NBR := 1; TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'fr', unistr('Message'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'es', unistr('Mensaje'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'ru', unistr('\0441\043E\043E\0431\0449\0435\043D\0438\0435'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'ar', unistr('\0631\0633\0627\0644\0629'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('MSG', :VERSION_NBR, 'zh', unistr('\6D88\606F'));

-- Notes, note text type properties, and note descriptions

execute TEXT_TYPE.INSERT_TEXT_TYPE('NOTE', 'en', 'Note');

execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'TAB', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'TXTT', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'TTP', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LANG', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'COMP', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'MSG', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'USR', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'UATT', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'UAT', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'SYP', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOC', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCT', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCAT', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCA', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCRT', 'N', 'Y', 'Y');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NOTE', 'LOCR', 'N', 'Y', 'Y');

execute :VERSION_NBR := 1; TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'fr', unistr('Remarque'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'es', unistr('Nota'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'ru', unistr('\043F\0440\0438\043C\0435\0447\0430\043D\0438\0435'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'ar', unistr('\0645\0630\0643\0631\0629'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NOTE', :VERSION_NBR, 'zh', unistr('\8BF7\6CE8\610F'));

-- Names, name text type properties, and name descriptions

execute TEXT_TYPE.INSERT_TEXT_TYPE('NAME', 'en', 'Name');

execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NAME', 'USR');
execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('NAME', 'LOC');

execute :VERSION_NBR := 1; TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'fr', unistr('Nom'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'es', unistr('Nombre'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'ru', unistr('\0438\043C\044F'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'ar', unistr('\0627\0633\0645'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('NAME', :VERSION_NBR, 'zh', unistr('\540D\79F0'));

-- Formal names for locations

execute TEXT_TYPE.INSERT_TEXT_TYPE('FORMALNAME', 'en', 'Formal name');

execute TEXT_TYPE.INSERT_TEXT_TYPE_PROPERTIES('FORMALNAME', 'LOC');

execute :VERSION_NBR := 1; TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'fr', unistr('Nom officiel'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'es', unistr('Nombre formal'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'ru', unistr('\041E\0444\0438\0446\0438\0430\043B\044C\043D\043E\0435 \043D\0430\0437\0432\0430\043D\0438\0435'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'ar', unistr('\0627\0633\0645 \0631\0633\0645\064A'));
execute TEXT_TYPE.SET_TXTT_DESCRIPTION('FORMALNAME', :VERSION_NBR, 'zh', unistr('\6B63\5F0F\540D\79F0'));
