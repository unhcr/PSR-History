execute P_STATISTIC_TYPE.INSERT_STATISTIC_GROUP('ASR', 'en', 'Annual Statistics Report');
execute P_STATISTIC_TYPE.INSERT_STATISTIC_GROUP('STOCK', 'en', 'Stock statistics');
execute P_STATISTIC_TYPE.INSERT_STATISTIC_GROUP('FLOW', 'en', 'Flow statistics');

execute P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE('POCPOP', 'en', 'Population of persons of concern (stock)');
execute P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING('ASR', 'POCPOP');
execute P_STATISTIC_TYPE.INSERT_STATISTIC_TYPE_GROUPING('STOCK', 'POCPOP');
