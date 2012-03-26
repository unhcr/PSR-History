-- Components
execute MESSAGE.INSERT_COMPONENT('GEN', 'en', 'General');
execute MESSAGE.INSERT_COMPONENT('TXTT', 'en', 'Text Types');
execute MESSAGE.INSERT_COMPONENT('LANG', 'en', 'Languages');
execute MESSAGE.INSERT_COMPONENT('TXT', 'en', 'Text');
execute MESSAGE.INSERT_COMPONENT('MSG', 'en', 'Messages and Components');
execute MESSAGE.INSERT_COMPONENT('SYP', 'en', 'System parameters');
execute MESSAGE.INSERT_COMPONENT('USR', 'en', 'System users, user attributes and user preferences');
execute MESSAGE.INSERT_COMPONENT('LOC', 'en', 'Locations, location attributes and location relationships');

-- Messages
variable SEQ_NBR number;
execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('GEN', :SEQ_NBR, 'en', 'Module name mismatch');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('GEN', :SEQ_NBR, 'en', 'Module version mismatch');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type has been updated by another user');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type property has been updated by another user');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Nothing to be updated');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Language has been updated by another user');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Nothing to be updated');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text type');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Inactive text type');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text language');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Inactive text language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot specify a text item sequence number without a text identifier');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Wrong table for this text identifier');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Only one text item of this type allowed');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'No existing text of this type');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text item sequence number greater than current maximum');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'No text to delete');
execute :SEQ_NBR := null /* 11 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot delete last mandatory text item');
execute :SEQ_NBR := null /* 12 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot delete mandatory text type');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message not found', 'S');
execute :VERSION_NBR := 1; MESSAGE.SET_MSG_MESSAGE('MSG', :SEQ_NBR, :VERSION_NBR, 'fr', 'Message introuvable');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Invalid severity', 'S');
execute :VERSION_NBR := 1; MESSAGE.SET_MSG_MESSAGE('MSG', :SEQ_NBR, :VERSION_NBR, 'fr', unistr('S\00E9v\00E9rit\00E9 invalide'));
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'English message not found', 'S');
execute :VERSION_NBR := 1; MESSAGE.SET_MSG_MESSAGE('MSG', :SEQ_NBR, :VERSION_NBR, 'fr', 'Message anglais introuvable');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'English message mismatch', 'S');
execute :VERSION_NBR := 1; MESSAGE.SET_MSG_MESSAGE('MSG', :SEQ_NBR, :VERSION_NBR, 'fr', unistr('Disparit\00E9 de message anglais'));
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Component has been updated by another user');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message has been updated by another user');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Component does not exist');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message sequence number greater than current maximum');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message language cannot be specified without message text');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('SYP', :SEQ_NBR, 'en', 'System parameter has been updated by another user');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'System user has been updated by another user');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'User attribute type has been updated by another user');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'User attribute has been updated by another user');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'User language preference has been updated by another user');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'Cannot update data type of user attribute type already in use');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'Inactive user attribute type');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'Attribute of the correct type must be specified');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'Unknown user attribute type');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('USR', :SEQ_NBR, 'en', 'Inactive preference language');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location type has been updated by another user');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location has been updated by another user');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location attribute type has been updated by another user');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location attribute has been updated by another user');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location relationship type has been updated by another user');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location relationship has been updated by another user');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Country code must be specified for new country');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Country with this code already exists');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Country code can only be specified for countries');
execute :SEQ_NBR := null /* 11 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Location type cannot be updated');
execute :SEQ_NBR := null /* 12 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Cannot update data type of location attribute type already in use');
execute :SEQ_NBR := null /* 13 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Inactive location attribute type');
execute :SEQ_NBR := null /* 14 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Attribute of the correct type must be specified');
execute :SEQ_NBR := null /* 15 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Inactive location relationship type');
execute :SEQ_NBR := null /* 16 */; MESSAGE.INSERT_MESSAGE('LOC', :SEQ_NBR, 'en', 'Overlapping location relationship already exists');
