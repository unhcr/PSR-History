-- Components
execute MESSAGE.SET_COMPONENT('GEN', 'en', 'General');
execute MESSAGE.SET_COMPONENT('TXTT', 'en', 'Text Types');
execute MESSAGE.SET_COMPONENT('LANG', 'en', 'Languages');
execute MESSAGE.SET_COMPONENT('TXT', 'en', 'Text');
execute MESSAGE.SET_COMPONENT('MSG', 'en', 'Messages and Components');
execute MESSAGE.SET_COMPONENT('SYP', 'en', 'System parameters');
execute MESSAGE.SET_COMPONENT('USR', 'en', 'System users, user attributes and user preferences');

-- Messages
variable SEQ_NBR number;
execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('GEN', :SEQ_NBR, 'en', 'Module name mismatch');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('GEN', :SEQ_NBR, 'en', 'Module version mismatch');

execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Description must be specified for new text type');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 3 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 4 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type does not exist');
execute :SEQ_NBR := null /* 7 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type must be specified');
execute :SEQ_NBR := null /* 8 */; MESSAGE.SET_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type property does not exist');

execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Description must be specified for new language');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 3 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 4 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Language does not exist');
execute :SEQ_NBR := null /* 7 */; MESSAGE.SET_MESSAGE('LANG', :SEQ_NBR, 'en', 'Text type must be specified');

execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text must be specified');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text type');
execute :SEQ_NBR := null /* 3 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Inactive text type');
execute :SEQ_NBR := null /* 4 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Inactive text language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot specify a text item sequence number without a text identifier');
execute :SEQ_NBR := null /* 7 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Wrong table for this text identifier');
execute :SEQ_NBR := null /* 8 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Only one text item of this type allowed');
execute :SEQ_NBR := null /* 9 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'No existing text of this type');
execute :SEQ_NBR := null /* 10 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text item sequence number greater than current maximum');
execute :SEQ_NBR := null /* 11 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'No text to delete');
execute :SEQ_NBR := null /* 12 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot delete last mandatory text item');
execute :SEQ_NBR := null /* 13 */; MESSAGE.SET_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot delete mandatory text type');

execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Description must be specified for new component');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 3 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 4 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Component does not exist');
execute :SEQ_NBR := null /* 7 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Text type must be specified');
execute :SEQ_NBR := null /* 8 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message text must be specified for new message');
execute :SEQ_NBR := null /* 9 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message language cannot be specified without message text');
execute :SEQ_NBR := null /* 10 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Unknown message language');
execute :SEQ_NBR := null /* 11 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Inactive message language');
execute :SEQ_NBR := null /* 12 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message sequence number greater than current maximum');
execute :SEQ_NBR := null /* 13 */; MESSAGE.SET_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message does not exist');

execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('SYP', :SEQ_NBR, 'en', 'System parameter does not exist');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('SYP', :SEQ_NBR, 'en', 'Text type must be specified');

execute :SEQ_NBR := null /* 1 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Description must be specified for new user attribute type');
execute :SEQ_NBR := null /* 2 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 3 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 4 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'User attribute type does not exist');
execute :SEQ_NBR := null /* 7 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Text type must be specified');
execute :SEQ_NBR := null /* 8 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Name must be specified for new user');
execute :SEQ_NBR := null /* 9 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Name language cannot be specified without name');
execute :SEQ_NBR := null /* 10 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Unknown name language');
execute :SEQ_NBR := null /* 11 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Inactive name language');
execute :SEQ_NBR := null /* 12 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'User does not exist');
execute :SEQ_NBR := null /* 13 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Unknown preference language');
execute :SEQ_NBR := null /* 14 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Inactive preference language');
execute :SEQ_NBR := null /* 15 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Language or preference sequence (or both) must be specified');
execute :SEQ_NBR := null /* 16 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Language preference does not exist');
execute :SEQ_NBR := null /* 17 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Cannot update data type of user attribute type already in use');
execute :SEQ_NBR := null /* 18 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'User attribute does not exist');
execute :SEQ_NBR := null /* 19 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Unknown user attribute type');
execute :SEQ_NBR := null /* 20 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Inactive user attribute type');
execute :SEQ_NBR := null /* 21 */; MESSAGE.SET_MESSAGE('USR', :SEQ_NBR, 'en', 'Attribute of the correct type must be specified');
