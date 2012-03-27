variable VERSION_NBR number;
variable TXI_SEQ_NBR number;

execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('FALLBACK LANGUAGE', 'en', 'System default language in the absence of any user preference', 'C', psCHAR_VALUE => 'en');
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('MINIMUM DATE', 'en', 'Minimum date value (earlier than any possible practical date)', 'D', pdDATE_VALUE => date '0001-01-01');
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('MAXIMUM DATE', 'en', 'Maximum date value (later than any possible practical date)', 'D', pdDATE_VALUE => timestamp '9999-12-31 23:59:59');
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('FALSE DATE', 'en', 'Impossible date value (used for parameter default values)', 'D', pdDATE_VALUE => date '1582-10-10');
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION CODE MULTIPLIER', 'en', 'Multiplier used in calculating hashed location code', 'N', pnNUM_VALUE => 242701457);
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION CODE INCREMENT', 'en', 'Increment used in calculating hashed location code', 'N', pnNUM_VALUE => 31415927);
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION CODE CHECK MULTIPLIER', 'en', 'Multiplier used in calculating check digits for location code', 'N', pnNUM_VALUE => 43);
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION CODE CHECK INCREMENT', 'en', 'Increment used in calculating check digits for location code', 'N', pnNUM_VALUE => 99);
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION CODE CHECK MODULUS', 'en', 'Modulus used in calculating check digits for location code', 'N', pnNUM_VALUE => 89);
execute P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('COUNTRY LOCAT CODE', 'en', 'Location type code for standard country code', 'C', psCHAR_VALUE => 'IS03166A3');
