variable VERSION_NBR number;
variable TXT_SEQ_NBR number;

execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('REF', 'en', 'Refugees', 1);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('ROC', 'en', 'Persons in a refugee-like situation', 2);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('ASY', 'en', 'Asylum seekers', 3);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RET', 'en', 'Returned refugees', 4);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RPT', 'en', 'Repatriated refugees', 4);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('IDP', 'en', 'Internally displaced persons', 5);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('IOC', 'en', 'Persons in an IDP-like situation', 6);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RDP', 'en', 'Persons returned from an IDP or IDP-like situation', 7);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('STA', 'en', 'Stateless persons', 8);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('OOC', 'en', 'Others of concern', 9);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RAS', 'en', 'Refugees and asylum seekers');
