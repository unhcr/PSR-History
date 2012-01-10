create or replace trigger TXTT_RBD_TEXT
before delete on TEXT_TYPES
for each row
begin
  TEXT.DELETE_TEXT(:old.TXT_ID);
end;
/

create or replace trigger LANG_RBD_TEXT
before delete on LANGUAGES
for each row
begin
  TEXT.DELETE_TEXT(:old.TXT_ID);
end;
/

create or replace trigger COMP_RBD_TEXT
before delete on COMPONENTS
for each row
begin
  TEXT.DELETE_TEXT(:old.TXT_ID);
end;
/

create or replace trigger MSG_RBD_TEXT
before delete on MESSAGES
for each row
begin
  TEXT.DELETE_TEXT(:old.TXT_ID);
end;
/
