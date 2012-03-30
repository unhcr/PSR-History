variable VERSION_NBR number;
variable TXI_SEQ_NBR number;
variable MSG_SEQ_NBR number;

execute P_MESSAGE.INSERT_COMPONENT('GEN', 'en', 'General');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('GEN', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used across all packages');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('GEN', :MSG_SEQ_NBR, 'en', 'Module name mismatch');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('GEN', :MSG_SEQ_NBR, 'en', 'Module version mismatch');


execute P_MESSAGE.INSERT_COMPONENT('AGP', 'en', 'Age profiles and ranges');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('AGP', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_AGE_PROFILE');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('AGP', :MSG_SEQ_NBR, 'en', 'Age profile has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('AGP', :MSG_SEQ_NBR, 'en', 'Age range has been updated by another user');
execute :MSG_SEQ_NBR := null /* 3 */; P_MESSAGE.INSERT_MESSAGE('AGP', :MSG_SEQ_NBR, 'en', 'Cannot change age range already in use');
execute :MSG_SEQ_NBR := null /* 4 */; P_MESSAGE.INSERT_MESSAGE('AGP', :MSG_SEQ_NBR, 'en', 'Overlapping age ranges for this age profile');


execute P_MESSAGE.INSERT_COMPONENT('LANG', 'en', 'Languages');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('LANG', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_LANGUAGE');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('LANG', :MSG_SEQ_NBR, 'en', 'Language has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('LOC', 'en', 'Locations, location attributes and location relationships');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('LOC', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_LOCATION');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location has been updated by another user');
execute :MSG_SEQ_NBR := null /* 3 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location attribute type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 4 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location attribute has been updated by another user');
execute :MSG_SEQ_NBR := null /* 5 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location relationship type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 6 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location relationship has been updated by another user');
execute :MSG_SEQ_NBR := null /* 7 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Country code must be specified for new country');
execute :MSG_SEQ_NBR := null /* 8 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Country with this code already exists');
execute :MSG_SEQ_NBR := null /* 9 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Country code can only be specified for countries');
execute :MSG_SEQ_NBR := null /* 10 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Location type cannot be updated');
execute :MSG_SEQ_NBR := null /* 11 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Cannot update data type of location attribute type already in use');
execute :MSG_SEQ_NBR := null /* 12 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Inactive location attribute type');
execute :MSG_SEQ_NBR := null /* 13 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Attribute of the correct type must be specified');
execute :MSG_SEQ_NBR := null /* 14 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Inactive location relationship type');
execute :MSG_SEQ_NBR := null /* 15 */; P_MESSAGE.INSERT_MESSAGE('LOC', :MSG_SEQ_NBR, 'en', 'Overlapping location relationship already exists');


execute P_MESSAGE.INSERT_COMPONENT('MSG', 'en', 'Messages and Components');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('MSG', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_MESSAGE');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'Message not found', 'S');
execute :VERSION_NBR := 1; P_MESSAGE.SET_MSG_MESSAGE('MSG', :MSG_SEQ_NBR, :VERSION_NBR, 'fr', 'Message introuvable');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'Invalid severity', 'S');
execute :VERSION_NBR := 1; P_MESSAGE.SET_MSG_MESSAGE('MSG', :MSG_SEQ_NBR, :VERSION_NBR, 'fr', unistr('S\00E9v\00E9rit\00E9 invalide'));
execute :MSG_SEQ_NBR := null /* 3 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'English message not found', 'S');
execute :VERSION_NBR := 1; P_MESSAGE.SET_MSG_MESSAGE('MSG', :MSG_SEQ_NBR, :VERSION_NBR, 'fr', 'Message anglais introuvable');
execute :MSG_SEQ_NBR := null /* 4 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'English message mismatch', 'S');
execute :VERSION_NBR := 1; P_MESSAGE.SET_MSG_MESSAGE('MSG', :MSG_SEQ_NBR, :VERSION_NBR, 'fr', unistr('Disparit\00E9 de message anglais'));
execute :MSG_SEQ_NBR := null /* 5 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'Component has been updated by another user');
execute :MSG_SEQ_NBR := null /* 6 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'Message has been updated by another user');
execute :MSG_SEQ_NBR := null /* 7 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'Component does not exist');
execute :MSG_SEQ_NBR := null /* 8 */; P_MESSAGE.INSERT_MESSAGE('MSG', :MSG_SEQ_NBR, 'en', 'Message sequence number greater than current maximum');


execute P_MESSAGE.INSERT_COMPONENT('PER', 'en', 'Time periods');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('PER', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_TIME_PERIOD');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('PER', :MSG_SEQ_NBR, 'en', 'Time period type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('PER', :MSG_SEQ_NBR, 'en', 'Time period has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('POPC', 'en', 'Population categories');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('POPC', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_POPULATION_CATEGORY');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('POPC', :MSG_SEQ_NBR, 'en', 'Population category has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('PPG', 'en', 'Population planning groups');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('PPG', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_POPULATION_PLANNING_GROUP');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('PPG', :MSG_SEQ_NBR, 'en', 'PPG has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('PPG', :MSG_SEQ_NBR, 'en', 'PPG with overlapping dates already exists');


execute P_MESSAGE.INSERT_COMPONENT('STC', 'en', 'Statistics');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('STC', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_STATISTIC');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('STC', :MSG_SEQ_NBR, 'en', 'Statistic has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('STCT', 'en', 'Statistic types and groups');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('STCT', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_STATISTIC_TYPE');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('STCT', :MSG_SEQ_NBR, 'en', 'Statistic type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('STCT', :MSG_SEQ_NBR, 'en', 'Statistic group has been updated by another user');
execute :MSG_SEQ_NBR := null /* 3 */; P_MESSAGE.INSERT_MESSAGE('STCT', :MSG_SEQ_NBR, 'en', 'Statistic type grouping has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('SYP', 'en', 'System parameters');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('SYP', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_SYSTEM_PARAMETER');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('SYP', :MSG_SEQ_NBR, 'en', 'System parameter has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('TXT', 'en', 'Text');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('TXT', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_TEXT');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Unknown text type');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Inactive text type');
execute :MSG_SEQ_NBR := null /* 3 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Unknown text language');
execute :MSG_SEQ_NBR := null /* 4 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Inactive text language');
execute :MSG_SEQ_NBR := null /* 5 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Cannot specify a text item sequence number without a text identifier');
execute :MSG_SEQ_NBR := null /* 6 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Wrong table for this text identifier');
execute :MSG_SEQ_NBR := null /* 7 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Only one text item of this type allowed');
execute :MSG_SEQ_NBR := null /* 8 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'No existing text of this type');
execute :MSG_SEQ_NBR := null /* 9 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Text item sequence number greater than current maximum');
execute :MSG_SEQ_NBR := null /* 10 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'No text to delete');
execute :MSG_SEQ_NBR := null /* 11 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Cannot delete last mandatory text item');
execute :MSG_SEQ_NBR := null /* 12 */; P_MESSAGE.INSERT_MESSAGE('TXT', :MSG_SEQ_NBR, 'en', 'Cannot delete mandatory text type');


execute P_MESSAGE.INSERT_COMPONENT('TXTT', 'en', 'Text Types');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('TXTT', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_TEXT_TYPE');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('TXTT', :MSG_SEQ_NBR, 'en', 'Text type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('TXTT', :MSG_SEQ_NBR, 'en', 'Text type property has been updated by another user');


execute P_MESSAGE.INSERT_COMPONENT('USR', 'en', 'System users, user attributes and user preferences');
execute :VERSION_NBR := 1; :TXI_SEQ_NBR := null; P_MESSAGE.SET_COMP_TEXT('USR', :VERSION_NBR, 'NOTE', :TXI_SEQ_NBR, 'en', 'Used in package P_SYSTEM_USER');

execute :MSG_SEQ_NBR := null /* 1 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'System user has been updated by another user');
execute :MSG_SEQ_NBR := null /* 2 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'User attribute type has been updated by another user');
execute :MSG_SEQ_NBR := null /* 3 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'User attribute has been updated by another user');
execute :MSG_SEQ_NBR := null /* 4 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'User language preference has been updated by another user');
execute :MSG_SEQ_NBR := null /* 5 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'Cannot update data type of user attribute type already in use');
execute :MSG_SEQ_NBR := null /* 6 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'Inactive user attribute type');
execute :MSG_SEQ_NBR := null /* 7 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'Attribute of the correct type must be specified');
execute :MSG_SEQ_NBR := null /* 8 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'Unknown user attribute type');
execute :MSG_SEQ_NBR := null /* 9 */; P_MESSAGE.INSERT_MESSAGE('USR', :MSG_SEQ_NBR, 'en', 'Inactive preference language');
