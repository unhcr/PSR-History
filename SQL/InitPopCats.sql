variable VERSION_NBR number;
variable TXI_SEQ_NBR number;

execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('ASY', 'en', 'Asylum seekers');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('IDP', 'en', 'Internally displaced persons');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('IOC', 'en', '(?) Internally displaced others of concern');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('OOC', 'en', 'Others of concern');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('RAS', 'en', '(?) Returnee asylum seekers');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('RDP', 'en', '(?) Returned internally displaced persons');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('REF', 'en', 'Refugees');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('RET', 'en', 'Returnee refugees');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('ROC', 'en', '(?) Returnee others of concern');
execute P_POPULATION_CATEGORY.INSERT_POPULATION_CATEGORY('STA', 'en', 'Stateless persons');
