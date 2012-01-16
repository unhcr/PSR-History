-- Components
execute MESSAGE.INSERT_COMPONENT('GEN', 'en', 'General');
execute MESSAGE.INSERT_COMPONENT('TXTT', 'en', 'Text Types');
execute MESSAGE.INSERT_COMPONENT('LANG', 'en', 'Languages');
execute MESSAGE.INSERT_COMPONENT('TXT', 'en', 'Text');
execute MESSAGE.INSERT_COMPONENT('MSG', 'en', 'Messages and Components');

-- Messages
variable SEQ_NBR number;
execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('GEN', :SEQ_NBR, 'en', 'Module name mismatch');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('GEN', :SEQ_NBR, 'en', 'Module version mismatch');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Description language must be specified');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type does not exist');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type must be specified');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type still in use');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('TXTT', :SEQ_NBR, 'en', 'Text type property does not exist');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Language already exists');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Active flag must be Y or N');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Description language must be specified');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Language does not exist');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Text type must be specified');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('LANG', :SEQ_NBR, 'en', 'Language still in use');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Either text identifier or table alias must be specified');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot specify a text item sequence number without a text identifier');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown table alias');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text type');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Inactive text type');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text of this type not allowed for this table');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text identifier');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Wrong table for this text identifier');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Only one text item of this type allowed');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'No existing text of this type');
execute :SEQ_NBR := null /* 11 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text item sequence number greater than current maximum');
execute :SEQ_NBR := null /* 12 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Unknown text language');
execute :SEQ_NBR := null /* 13 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Inactive text language');
execute :SEQ_NBR := null /* 14 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text item already exists');
execute :SEQ_NBR := null /* 15 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text must be specified');
execute :SEQ_NBR := null /* 16 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Text item does not exist');
execute :SEQ_NBR := null /* 17 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'No text to delete');
execute :SEQ_NBR := null /* 18 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot delete last mandatory text item');
execute :SEQ_NBR := null /* 19 */; MESSAGE.INSERT_MESSAGE('TXT', :SEQ_NBR, 'en', 'Cannot delete mandatory text type');

execute :SEQ_NBR := null /* 1 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Component already exists');
execute :SEQ_NBR := null /* 2 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Active flag must be Y or N');
execute :SEQ_NBR := null /* 3 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Description language must be specified');
execute :SEQ_NBR := null /* 4 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Unknown description language');
execute :SEQ_NBR := null /* 5 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Inactive description language');
execute :SEQ_NBR := null /* 6 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Component does not exist');
execute :SEQ_NBR := null /* 7 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Description language cannot be specified without description text');
execute :SEQ_NBR := null /* 8 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Nothing to be updated');
execute :SEQ_NBR := null /* 9 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Text type must be specified');
execute :SEQ_NBR := null /* 10 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Component still in use');
execute :SEQ_NBR := null /* 11 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message sequence number greater than current maximum');
execute :SEQ_NBR := null /* 12 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message already exists');
execute :SEQ_NBR := null /* 13 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Severity must be System error, Error, Warning or Information');
execute :SEQ_NBR := null /* 14 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message language must be specified');
execute :SEQ_NBR := null /* 15 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Unknown message language');
execute :SEQ_NBR := null /* 16 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Inactive message language');
execute :SEQ_NBR := null /* 17 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message does not exist');
execute :SEQ_NBR := null /* 18 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Message language cannot be specified without message text');
execute :SEQ_NBR := null /* 19 */; MESSAGE.INSERT_MESSAGE('MSG', :SEQ_NBR, 'en', 'Nothing to be updated');
