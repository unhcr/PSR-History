create or replace package body TEXT is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- INSERT_TEXT
-- ----------------------------------------
--
  procedure INSERT_TEXT
   (pnTXT_ID in out TEXT_HEADERS.ID%type,
    psTAB_ALIAS in TEXT_HEADERS.TAB_ALIAS%type,
    psTXTT_CODE in TEXT_TYPES.CODE%type,
    pnSEQ_NBR in out TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in LANGUAGES.CODE%type,
    psTEXT in varchar2)
  is
    sActive varchar2(1);
    sTAB_ALIAS TEXT_HEADERS.TAB_ALIAS%type;
    sMULTI_INSTANCE TEXT_TYPE_PROPERTIES.MULTI_INSTANCE%type;
    nTXI_SEQ_NBR_MAX TEXT_TYPE_HEADERS.TXI_SEQ_NBR_MAX%type;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.INSERT_TEXT',
                             to_char(pnTXT_ID) || '~' || psTAB_ALIAS || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                               to_char(length(psTEXT)) || ':' || psTEXT);
  --
    if pnTXT_ID is null
    then
    --
    -- Text is to be created for a new entity.
    --
      if psTAB_ALIAS is null
      then MESSAGE.DISPLAY_MESSAGE('TXT', 1, 'en', 'Either text identifier or table alias must be specified');
      end if;
    --
      if pnSEQ_NBR is not null
      then MESSAGE.DISPLAY_MESSAGE('TXT', 2, 'en', 'Cannot specify a text item sequence number without a text identifier');
      end if;
    --
    -- Create new TEXT_HEADERS row.
    --
      begin
        insert into TEXT_HEADERS (TAB_ALIAS)
        values (psTAB_ALIAS)
        returning ID into pnTXT_ID;
      exception
        when others
        then
          if sqlcode = -2291  -- Integrity constraint violated - parent key not found
          then MESSAGE.DISPLAY_MESSAGE('TXT', 3, 'en', 'Unknown table alias');
          else raise;
          end if;
      end;
    --
      PLS_UTILITY.TRACE_POINT('Inserted TEXT_HEADERS',
                              to_char(pnTXT_ID) || '~' || psTAB_ALIAS || '~' || psTXTT_CODE || '~' ||
                                to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                                to_char(length(psTEXT)) || ':' || psTEXT);
    --
    -- Create new TEXT_TYPE_HEADERS row, ensuring required text type is active.
    --
      begin
        select TXTT.ACTIVE_FLAG
        into sActive
        from TEXT_TYPES TXTT
        where TXTT.CODE = psTXTT_CODE
        for update;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('TXT', 4, 'en', 'Unknown text type');
      end;
    --
      if sActive = 'N'
      then MESSAGE.DISPLAY_MESSAGE('TXT', 5, 'en', 'Inactive text type');
      end if;
    --
      insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX)
      values (pnTXT_ID, psTXTT_CODE, psTAB_ALIAS, 1);
    --
      PLS_UTILITY.TRACE_POINT('Inserted TEXT_TYPE_HEADERS');
    --
      pnSEQ_NBR := 1;
    --
    else
      begin
        select TAB_ALIAS into sTAB_ALIAS from TEXT_HEADERS TXT where TXT.ID = pnTXT_ID;
      exception
        when NO_DATA_FOUND
        then MESSAGE.DISPLAY_MESSAGE('TXT', 7, 'en', 'Unknown text identifier');
      end;
    --
      if sTAB_ALIAS != psTAB_ALIAS
      then MESSAGE.DISPLAY_MESSAGE('TXT', 8, 'en', 'Wrong table for this text identifier');
      end if;
    --
      if pnSEQ_NBR is null
      then
      --
      -- Check if there are any existing text items of the required type.
      --
        update TEXT_TYPE_HEADERS
        set TXI_SEQ_NBR_MAX = TXI_SEQ_NBR_MAX + 1
        where TXT_ID = pnTXT_ID
        and TXTT_CODE = psTXTT_CODE
        returning TXI_SEQ_NBR_MAX into pnSEQ_NBR;
      --
        PLS_UTILITY.TRACE_POINT('Updated TEXT_TYPE_HEADERS',
                                to_char(pnTXT_ID) || '~' || psTAB_ALIAS || '~' || psTXTT_CODE ||
                                  '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                                  to_char(length(psTEXT)) || ':' || psTEXT);
      --
        if sql%rowcount = 0
        then
        --
        -- Entity has no existing text items of this type: create new TEXT_TYPE_HEADERS row,
        --  ensuring required text type is active.
        --
          begin
            select ACTIVE_FLAG into sActive from TEXT_TYPES where CODE = psTXTT_CODE for update;
          exception
            when NO_DATA_FOUND
            then MESSAGE.DISPLAY_MESSAGE('TXT', 4, 'en', 'Unknown text type');
          end;
        --
          if sActive = 'N'
          then MESSAGE.DISPLAY_MESSAGE('TXT', 5, 'en', 'Inactive text type');
          end if;
        --
          insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX)
          values (pnTXT_ID, psTXTT_CODE, sTAB_ALIAS, 1);
        --
          PLS_UTILITY.TRACE_POINT('Inserted TEXT_TYPE_HEADERS');
        --
          pnSEQ_NBR := 1;
        --
        elsif sMULTI_INSTANCE = 'N'
        then MESSAGE.DISPLAY_MESSAGE('TXT', 9, 'en', 'Only one text item of this type allowed');
        end if;
      else
      --
      -- Check that TEXT_TYPE_HEADERS row exists and requested text item sequence number is not
      --  greater than the current maximum.
      --
        begin
          select TXI_SEQ_NBR_MAX
          into nTXI_SEQ_NBR_MAX
          from TEXT_TYPE_HEADERS
          where TXT_ID = pnTXT_ID
          and TXTT_CODE = psTXTT_CODE;
        exception
          when NO_DATA_FOUND
          then MESSAGE.DISPLAY_MESSAGE('TXT', 10, 'en', 'No existing text of this type');
        end;
      --
        if pnSEQ_NBR > nTXI_SEQ_NBR_MAX
        then MESSAGE.DISPLAY_MESSAGE('TXT', 11, 'en', 'Text item sequence number greater than current maximum');
        end if;
      end if;
    end if;
  --
  -- Create new TEXT_ITEMS row, ensuring required language is active.
  --
    begin
      select ACTIVE_FLAG into sActive from LANGUAGES where CODE = psLANG_CODE for update;
    exception
      when NO_DATA_FOUND
      then MESSAGE.DISPLAY_MESSAGE('TXT', 12, 'en', 'Unknown text language');
    end;
  --
    if sActive = 'N'
    then MESSAGE.DISPLAY_MESSAGE('TXT', 13, 'en', 'Inactive text language');
    end if;
  --
    begin
      if length(psTEXT) <= 1000
      then
        insert into TEXT_ITEMS (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TEXT)
        values (pnTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psTEXT);
      else
        insert into TEXT_ITEMS (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, LONG_TEXT)
        values (pnTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, psTEXT);
      end if;
    exception
      when DUP_VAL_ON_INDEX
      then MESSAGE.DISPLAY_MESSAGE('TXT', 14, 'en', 'Text message already exists');
    --
      when others
      then
        if sqlcode = -2290  -- Check constraint violated
          and sqlerrm like '%CH_TXI_TEXT%'
        then MESSAGE.DISPLAY_MESSAGE('TXT', 15, 'en', 'Text message must be specified');
        else raise;
        end if;
    end;
  --
    PLS_UTILITY.TRACE_POINT('Inserted TEXT_ITEMS',
                            to_char(pnTXT_ID) || '~' || psTAB_ALIAS || '~' || psTXTT_CODE || '~' ||
                              to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
                              to_char(length(psTEXT)) || ':' || psTEXT);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end INSERT_TEXT;
--
-- ----------------------------------------
-- UPDATE_TEXT
-- ----------------------------------------
--
  procedure UPDATE_TEXT
   (pnTXT_ID in TEXT_ITEMS.TXT_ID%type,
    psTXTT_CODE in TEXT_ITEMS.TXTT_CODE%type,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type,
    psLANG_CODE in TEXT_ITEMS.LANG_CODE%type,
    psTEXT in varchar2)
  is
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.UPDATE_TEXT',
                             to_char(pnTXT_ID) || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE|| '~' ||
                               to_char(length(psTEXT)) || ':' || psTEXT);
  --
    begin
      if length(psTEXT) <= 1000
      then
        update TEXT_ITEMS
        set TEXT = psTEXT, LONG_TEXT = null
        where TXT_ID = pnTXT_ID
        and TXTT_CODE = psTXTT_CODE
        and SEQ_NBR = pnSEQ_NBR
        and LANG_CODE = psLANG_CODE;
      else
        update TEXT_ITEMS
        set TEXT = null, LONG_TEXT = psTEXT
        where TXT_ID = pnTXT_ID
        and TXTT_CODE = psTXTT_CODE
        and SEQ_NBR = pnSEQ_NBR
        and LANG_CODE = psLANG_CODE;
      end if;
    exception
      when others
      then
        if sqlcode = -2290  -- Check constraint violated
          and sqlerrm like '%CH_TXI_TEXT%'
        then MESSAGE.DISPLAY_MESSAGE('TXT', 15, 'en', 'Text message must be specified');
        else raise;
        end if;
    end;
  --
    if sql%rowcount = 0
    then MESSAGE.DISPLAY_MESSAGE('TXT', 16, 'en', 'Text item does not exist');
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end UPDATE_TEXT;
--
-- ----------------------------------------
-- DELETE_TEXT
-- ----------------------------------------
--
  procedure DELETE_TEXT
   (pnTXT_ID in TEXT_HEADERS.ID%type,
    psTXTT_CODE in TEXT_TYPE_HEADERS.TXTT_CODE%type := null,
    pnSEQ_NBR in TEXT_ITEMS.SEQ_NBR%type := null,
    psLANG_CODE in TEXT_ITEMS.LANG_CODE%type := null)
  is
    sMANDATORY TEXT_TYPE_PROPERTIES.MANDATORY%type;
    nItemCount1 integer;
    nItemCount2 integer;
  begin
    PLS_UTILITY.START_MODULE(sVersion || '-' || sModule || '.DELETE_TEXT',
                             to_char(pnTXT_ID) || '~' || psTXTT_CODE || '~' ||
                               to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
    if psTXTT_CODE is not null
    then
      begin
        select TTP.MANDATORY
        into sMANDATORY
        from TEXT_HEADERS TXT
        join TEXT_TYPE_PROPERTIES TTP
          on TTP.TAB_ALIAS = TXT.TAB_ALIAS
          and TTP.TXTT_CODE = psTXTT_CODE
        where TXT.ID = pnTXT_ID;
      exception
        when NO_DATA_FOUND
        then sMANDATORY := 'N';
      end;
    end if;
  --
    if psLANG_CODE is not null
    then
    --
    -- Count number of text items to be deleted / left undeleted.
    --
      select count(*), count(case when SEQ_NBR = pnSEQ_NBR and LANG_CODE = psLANG_CODE then 1 end)
      into nItemCount1, nItemCount2
      from TEXT_ITEMS
      where TXT_ID = pnTXT_ID
      and TXTT_CODE = psTXTT_CODE;
    --
      if nItemCount2 = 0
      then MESSAGE.DISPLAY_MESSAGE('TXT', 17, 'en', 'No text to delete');
      end if;
    --
      if nItemCount1 = nItemCount2
      then
      --
      -- Single text item of this type is to be deleted.
      --
        if sMANDATORY = 'Y'
        then MESSAGE.DISPLAY_MESSAGE('TXT', 18, 'en', 'Cannot delete last mandatory text item');
        else
        --
        -- The single subordinate TEXT_ITEMS row will be cascade deleted.
        --
          delete from TEXT_TYPE_HEADERS where TXT_ID = pnTXT_ID and TXTT_CODE = psTXTT_CODE;
        --
          PLS_UTILITY.TRACE_POINT('Deleted TEXT_TYPE_HEADERS-A~' || to_char(sql%rowcount));
        end if;
      else
      --
      -- Just one of several text items of this type is to be deleted.
      --
        delete from TEXT_ITEMS
        where TXT_ID = pnTXT_ID
        and TXTT_CODE = psTXTT_CODE
        and SEQ_NBR = pnSEQ_NBR
        and LANG_CODE = psLANG_CODE;
      --
        PLS_UTILITY.TRACE_POINT('Deleted TEXT_ITEMS-A~' || to_char(sql%rowcount));
      end if;
    --
    elsif pnSEQ_NBR is not null
    then
    --
    -- Count number of text items to be deleted / left undeleted.
    --
      select count(*), count(case when SEQ_NBR = pnSEQ_NBR then 1 end)
      into nItemCount1, nItemCount2
      from TEXT_ITEMS
      where TXT_ID = pnTXT_ID
      and TXTT_CODE = psTXTT_CODE;
    --
      if nItemCount2 = 0
      then MESSAGE.DISPLAY_MESSAGE('TXT', 17, 'en', 'No text to delete');
      end if;
    --
      if nItemCount1 = nItemCount2
      then
      --
      -- All text items of this type are to be deleted.
      --
        if sMANDATORY = 'Y'
        then MESSAGE.DISPLAY_MESSAGE('TXT', 18, 'en', 'Cannot delete last mandatory text item');
        else
        --
        -- The subordinate TEXT_ITEMS rows will be cascade deleted.
        --
          delete from TEXT_TYPE_HEADERS where TXT_ID = pnTXT_ID and TXTT_CODE = psTXTT_CODE;
        --
          PLS_UTILITY.TRACE_POINT('Deleted TEXT_TYPE_HEADERS-B~' || to_char(sql%rowcount));
        end if;
      else
      --
      -- Not all the text items of this type are to be deleted.
      --
        delete from TEXT_ITEMS
        where TXT_ID = pnTXT_ID
        and TXTT_CODE = psTXTT_CODE
        and SEQ_NBR = pnSEQ_NBR;
      --
        PLS_UTILITY.TRACE_POINT('Deleted TEXT_ITEMS-B~' || to_char(sql%rowcount));
      end if;
    --
    elsif psTXTT_CODE is not null
    then
      if sMANDATORY = 'Y'
      then MESSAGE.DISPLAY_MESSAGE('TXT', 19, 'en', 'Cannot delete mandatory text type');
      end if;
    --
    -- Subordinate TEXT_ITEMS rows will be cascade deleted.
    --
      delete from TEXT_TYPE_HEADERS where TXT_ID = pnTXT_ID and TXTT_CODE = psTXTT_CODE;
    --
      PLS_UTILITY.TRACE_POINT('Deleted TEXT_TYPE_HEADERS-C~' || to_char(sql%rowcount));
    --
      if sql%rowcount = 0
      then MESSAGE.DISPLAY_MESSAGE('TXT', 17, 'en', 'No text to delete');
      end if;
    else
    --
    -- Subordinate TEXT_TYPE_HEADERS and TEXT_ITEMS rows will be cascade deleted.
    --
      delete from TEXT_HEADERS where ID = pnTXT_ID;
    --
      PLS_UTILITY.TRACE_POINT('Deleted TEXT_HEADERS~' || to_char(sql%rowcount));
    --
      if sql%rowcount = 0
      then MESSAGE.DISPLAY_MESSAGE('TXT', 17, 'en', 'No text to delete');
      end if;
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.TRACE_EXCEPTION;
  end DELETE_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sModule != 'TEXT'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'en', 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'en', 'Module version mismatch');
  end if;
--
end TEXT;
/

show errors
