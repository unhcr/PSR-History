variable VERSION_NBR number;
variable TXI_SEQ_NBR number;

execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('REF', 'en', 'Refugees', 1);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('ROC', 'en', 'People in refugee-like situations', 2);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('ASY', 'en', 'Asylum seekers', 3);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('RET', 'en', 'Returned refugees', 4);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('IDP', 'en', 'Internally displaced persons', 5);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('IOC', 'en', 'People in IDP-like situations', 6);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('RDP', 'en', 'Returned internally displaced persons', 7);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('STA', 'en', 'Stateless persons', 8);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('OOC', 'en', 'Others of concern', 9);
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('RAS', 'en', 'Refugees and asylum seekers');
