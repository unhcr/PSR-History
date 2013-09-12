create role STANDARD_USER;
grant CONNECT, RESOURCE to STANDARD_USER;
grant create view, create materialized view, create synonym to STANDARD_USER;
revoke unlimited tablespace from STANDARD_USER;

create role PSR_STAGE;

create role PSR_PUBLIC_QUERY;
grant CONNECT to PSR_PUBLIC_QUERY;
grant create synonym to PSR_PUBLIC_QUERY;
