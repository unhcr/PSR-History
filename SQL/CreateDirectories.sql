create or replace directory PSRDATA as '/n02/RASRUAT/staging';
grant read, write on directory PSRDATA to PSR_STAGE;

create or replace directory PSRLOG as '/n02/RASRUAT/staging/log';
grant read, write on directory PSRLOG to PSR_STAGE;
