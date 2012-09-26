begin
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('MINIMUM DATE', 'en', 'Minimum date value (earlier than any possible practical date)', 'D', pdDATE_VALUE => date '0001-01-01');
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('MAXIMUM DATE', 'en', 'Maximum date value (later than any possible practical date)', 'D', pdDATE_VALUE => timestamp '9999-12-31 23:59:59');
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('FALSE DATE', 'en', 'Impossible date value (used for parameter default values)', 'D', pdDATE_VALUE => date '1582-10-10');
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION ID MULTIPLIER', 'en', 'Multiplier used in calculating hashed location identifier', 'N', pnNUM_VALUE => 242701457);
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION ID INCREMENT', 'en', 'Increment used in calculating hashed location identifier', 'N', pnNUM_VALUE => 31415927);
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION ID CHECK MULTIPLIER', 'en', 'Multiplier used in calculating check digits for location identifier', 'N', pnNUM_VALUE => 43);
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION ID CHECK INCREMENT', 'en', 'Increment used in calculating check digits for location identifier', 'N', pnNUM_VALUE => 99);
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('LOCATION ID CHECK MODULUS', 'en', 'Modulus used in calculating check digits for location identifier', 'N', pnNUM_VALUE => 89);
  P_SYSTEM_PARAMETER.INSERT_SYSTEM_PARAMETER('COUNTRY LOCAT CODE', 'en', 'Location type code for standard country code', 'C', psCHAR_VALUE => 'IS03166A3');
end;
/
