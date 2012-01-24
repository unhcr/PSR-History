-- Components
execute MESSAGE.SET_COMPONENT('GEN', 'en', 'General');
execute MESSAGE.SET_COMPONENT('TXTT', 'en', 'Text Types');
execute MESSAGE.SET_COMPONENT('LANG', 'en', 'Languages');
execute MESSAGE.SET_COMPONENT('TXT', 'en', 'Text');
execute MESSAGE.SET_COMPONENT('MSG', 'en', 'Messages and Components');

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
