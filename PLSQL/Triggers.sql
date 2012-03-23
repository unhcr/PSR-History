create or replace trigger TR_LOC_RBU_AUDIT
before update on LOCATIONS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_LOC_RBU_VERSION;
/


create or replace trigger TR_LOCA_RBU_AUDIT
before update on LOCATION_ATTRIBUTES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_LOCA_RBU_VERSION;
/


create or replace trigger TR_LOCR_RBU_AUDIT
before update on LOCATION_RELATIONSHIPS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_LOCR_RBU_VERSION;
/


create or replace trigger TR_USR_RBU_AUDIT
before update on SYSTEM_USERS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_USR_RBU_VERSION;
/


create or replace trigger TR_TXI_RBU_AUDIT
before update on TEXT_ITEMS
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_TXI_RBU_VERSION;
/


create or replace trigger TR_UAT_RBU_AUDIT
before update on USER_ATTRIBUTES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_UAT_RBU_AUDIT;
/


create or replace trigger TR_ULP_RBU_AUDIT
before update on USER_LANGUAGE_PREFERENCES
for each row
begin
  :new.UPDATE_TIMESTAMP := systimestamp;
  :new.UPDATE_USERID := nvl(sys_context('PSR', 'USERID'), '*' || user);
end TR_ULP_RBU_AUDIT;
/
