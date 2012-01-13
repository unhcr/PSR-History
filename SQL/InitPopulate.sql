-- Table aliases
-- =============

insert into TABLE_ALIASES (ALIAS, TABLE_NAME)
select substr(CONSTRAINT_NAME, 4), TABLE_NAME
from USER_CONSTRAINTS
where CONSTRAINT_TYPE = 'P';


-- Initial "bootstrapping" entries in text-related tables
-- ======================================================

variable TXT_ID number;
insert into TEXT_HEADERS (ID, TAB_ALIAS) values (TXT_SEQ.nextval, 'TXTT') returning ID into :TXT_ID;
insert into TEXT_TYPES (CODE, TXT_ID) values ('DESCR', TXT_SEQ.currval);
insert into TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY, MULTI_INSTANCE) values ('DESCR', 'TXTT', 'Y', 'N');
insert into TEXT_TYPE_PROPERTIES (TXTT_CODE, TAB_ALIAS, MANDATORY, MULTI_INSTANCE) values ('DESCR', 'LANG', 'Y', 'N');
insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX) values (TXT_SEQ.currval, 'DESCR', 'TXTT', 1);
insert into TEXT_HEADERS (ID, TAB_ALIAS) values (TXT_SEQ.nextval, 'LANG');
insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX) values (TXT_SEQ.currval, 'DESCR', 'LANG', 1);
insert into LANGUAGES (CODE, TXT_ID) values ('en', TXT_SEQ.currval);
insert into TEXT_ITEMS (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TEXT) values (:TXT_ID, 'DESCR', 1, 'en', 'Description');
insert into TEXT_ITEMS (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TEXT) values (TXT_SEQ.currval, 'DESCR', 1, 'en', 'English');


-- Languages
-- =========

-- All the UN languages
execute LANGUAGE.INSERT_LANGUAGE('fr', 'en', 'French');
execute LANGUAGE.INSERT_LANGUAGE('es', 'en', 'Spanish');
execute LANGUAGE.INSERT_LANGUAGE('ru', 'en', 'Russian');
execute LANGUAGE.INSERT_LANGUAGE('ar', 'en', 'Arabic');
execute LANGUAGE.INSERT_LANGUAGE('zh', 'en', 'Chinese');

-- Descriptions in all the UN languages

execute LANGUAGE.ADD_LANG_DESCRIPTION('en', 'fr', unistr('Anglais'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('en', 'es', unistr('Ingl\00E9s'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('en', 'ru', unistr('\0430\043D\0433\043B\0438\0439\0441\043A\0438\0439'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('en', 'ar', unistr('\0627\0644\0625\0646\062C\0644\064A\0632\064A\0629'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('en', 'zh', unistr('\82F1\8BED'));

execute LANGUAGE.ADD_LANG_DESCRIPTION('fr', 'fr', unistr('Fran\00E7ais'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('fr', 'es', unistr('Franc\00E9s'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('fr', 'ru', unistr('\0444\0440\0430\043D\0446\0443\0437\0441\043A\0438\0439'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('fr', 'ar', unistr('\0627\0644\0641\0631\0646\0633\064A\0629'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('fr', 'zh', unistr('\6CD5\56FD'));

execute LANGUAGE.ADD_LANG_DESCRIPTION('es', 'fr', unistr('Espagnol'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('es', 'es', unistr('Espa\00F1ol'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('es', 'ru', unistr('\0438\0441\043F\0430\043D\0441\043A\0438\0439'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('es', 'ar', unistr('\0627\0644\0623\0633\0628\0627\0646\064A\0629'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('es', 'zh', unistr('\897F\73ED\7259'));

execute LANGUAGE.ADD_LANG_DESCRIPTION('ru', 'fr', unistr('Russe'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ru', 'es', unistr('Ruso'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ru', 'ru', unistr('\0440\0443\0441\0441\043A\0438\0439'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ru', 'ar', unistr('\0627\0644\0631\0648\0633\064A\0629'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ru', 'zh', unistr('\4FC4\7F57\65AF'));

execute LANGUAGE.ADD_LANG_DESCRIPTION('ar', 'fr', unistr('Arabe'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ar', 'es', unistr('\00C1rabe'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ar', 'ru', unistr('\0430\0440\0430\0431\0441\043A\0438\0439'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ar', 'ar', unistr('\0627\0644\0639\0631\0628\064A\0629'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('ar', 'zh', unistr('\963F\62C9\4F2F\8BED'));

execute LANGUAGE.ADD_LANG_DESCRIPTION('zh', 'fr', unistr('Chinois'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('zh', 'es', unistr('Chino'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('zh', 'ru', unistr('\043A\0438\0442\0430\0439\0441\043A\0438\0439'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('zh', 'ar', unistr('\0627\0644\0635\064A\0646\064A\0629'));
execute LANGUAGE.ADD_LANG_DESCRIPTION('zh', 'zh', unistr('\4E2D\56FD'));

-- Inactive language for testing (English description only)

execute LANGUAGE.INSERT_LANGUAGE('la', 'en', 'Latin (inactive language for testing)', psACTIVE_FLAG => 'N');


-- Text types with descriptions in all UN languages and text type properties
-- =========================================================================

-- Description text type properties and description descriptions

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('DESCR', 'COMP', 'Y', 'N');

execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('DESCR', 'fr', unistr('Description'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('DESCR', 'es', unistr('Descripci\00F3n'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('DESCR', 'ru', unistr('\043E\043F\0438\0441\0430\043D\0438\0435'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('DESCR', 'ar', unistr('\0648\0635\0641'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('DESCR', 'zh', unistr('\8BF4\660E'));

-- Messages, message text type properties, and message descriptions

execute TEXT_TYPE.INSERT_TEXT_TYPE('MSG', 'en', 'Message');

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('MSG', 'MSG', 'Y', 'N');

execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('MSG', 'fr', unistr('Message'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('MSG', 'es', unistr('Mensaje'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('MSG', 'ru', unistr('\0441\043E\043E\0431\0449\0435\043D\0438\0435'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('MSG', 'ar', unistr('\0631\0633\0627\0644\0629'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('MSG', 'zh', unistr('\6D88\606F'));

-- Notes, note text type properties, and note descriptions

execute TEXT_TYPE.INSERT_TEXT_TYPE('NOTE', 'en', 'Note');

execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('NOTE', 'TAB');
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('NOTE', 'TXTT');
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('NOTE', 'TTP');
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('NOTE', 'LANG');
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('NOTE', 'COMP');
execute TEXT_TYPE.SET_TEXT_TYPE_PROPERTIES('NOTE', 'MSG');

execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('NOTE', 'fr', unistr('Remarque'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('NOTE', 'es', unistr('Nota'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('NOTE', 'ru', unistr('\043F\0440\0438\043C\0435\0447\0430\043D\0438\0435'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('NOTE', 'ar', unistr('\0645\0630\0643\0631\0629'));
execute TEXT_TYPE.ADD_TXTT_DESCRIPTION('NOTE', 'zh', unistr('\8BF7\6CE8\610F'));
