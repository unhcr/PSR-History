create role PSR_STAGE;

create role PSR_PUBLIC_QUERY;
grant CONNECT to PSR_PUBLIC_QUERY;
grant create synonym to PSR_PUBLIC_QUERY;