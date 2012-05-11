variable VERSION_NBR number;
variable TXT_SEQ_NBR number;

execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('REF', 'en', 'Refugees', 1);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('ROC', 'en', 'People in refugee-like situations', 2);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('ASY', 'en', 'Asylum seekers', 3);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RET', 'en', 'Returned refugees', 4);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('IDP', 'en', 'Internally displaced persons', 5);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('IOC', 'en', 'People in IDP-like situations', 6);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RDP', 'en', 'Returned internally displaced persons', 7);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('STA', 'en', 'Stateless persons', 8);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('OOC', 'en', 'Others of concern', 9);
execute P_DISPLACEMENT_STATUS.INSERT_DISPLACEMENT_STATUS('RAS', 'en', 'Refugees and asylum seekers');
