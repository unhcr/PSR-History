create or replace package body P_TEXT is
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- SET_TEXT
-- ----------------------------------------
--
  procedure SET_TEXT
   (pnTXT_ID in out P_BASE.tnTXT_ID,
    psTAB_ALIAS in P_BASE.tsTAB_ALIAS,
    psTXTT_CODE in P_BASE.tmsTXTT_CODE,
    pnSEQ_NBR in out P_BASE.tnTXI_SEQ_NBR,
    psLANG_CODE in P_BASE.tmsLANG_CODE,
    psTEXT in P_BASE.tmsText)
  is
    sTXTT_ACTIVE_FLAG P_BASE.tsTXTT_ACTIVE_FLAG;
    sLANG_ACTIVE_FLAG P_BASE.tsLANG_ACTIVE_FLAG;
    sTAB_ALIAS P_BASE.tsTAB_ALIAS := psTAB_ALIAS;
    sMULTI_INSTANCE_FLAG P_BASE.tsTTP_MULTI_INSTANCE_FLAG;
    nTXI_SEQ_NBR_MAX P_BASE.tnTXI_SEQ_NBR_MAX;
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.SET_TEXT',
      to_char(pnTXT_ID) || '~' || psTAB_ALIAS || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psTEXT)) || ':' || psTEXT);
  --
  -- Ensure required text type is active.
  --
    begin
      select ACTIVE_FLAG into sTXTT_ACTIVE_FLAG from TEXT_TYPES where CODE = psTXTT_CODE for update;
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 1, 'Unknown text type');
    end;
  --
    if sTXTT_ACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('TXT', 2, 'Inactive text type');
    end if;
  --
  -- Ensure required language is active.
  --
    begin
      select ACTIVE_FLAG into sLANG_ACTIVE_FLAG from LANGUAGES where CODE = psLANG_CODE for update;
    exception
      when NO_DATA_FOUND
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 3, 'Unknown text language');
    end;
  --
    if sLANG_ACTIVE_FLAG = 'N'
    then P_MESSAGE.DISPLAY_MESSAGE('TXT', 4, 'Inactive text language');
    end if;
  --
    if pnTXT_ID is null
    then
    --
    -- Text is to be created for a new entity.
    --
      if pnSEQ_NBR is not null
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 5, 'Cannot specify a text item sequence number without a text identifier');
      end if;
    --
    -- Create new TEXT_HEADERS row.
    --
      insert into TEXT_HEADERS (ID, TAB_ALIAS)
      values (TXT_SEQ.nextval, sTAB_ALIAS)
      returning ID into pnTXT_ID;
    --
      PLS_UTILITY.TRACE_POINT
       ('Inserted TEXT_HEADERS',
        to_char(pnTXT_ID) || '~' || sTAB_ALIAS || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
          '~' || psLANG_CODE || '~' || to_char(length(psTEXT)) || ':' || psTEXT);
    --
    -- Create new TEXT_TYPE_HEADERS row.
    --
      insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX)
      values (pnTXT_ID, psTXTT_CODE, sTAB_ALIAS, 1);
    --
      PLS_UTILITY.TRACE_POINT('Inserted TEXT_TYPE_HEADERS');
    --
      pnSEQ_NBR := 1;
    --
    else
    --
    -- Text already exists for this entity.
    --
      select TAB_ALIAS into sTAB_ALIAS from TEXT_HEADERS TXT where TXT.ID = pnTXT_ID;
    --
      if sTAB_ALIAS != psTAB_ALIAS
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 6, 'Wrong table for this text identifier');
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
        PLS_UTILITY.TRACE_POINT
         ('Updated TEXT_TYPE_HEADERS',
          to_char(pnTXT_ID) || '~' || sTAB_ALIAS || '~' || psTXTT_CODE || '~' ||
            to_char(pnSEQ_NBR) || '~' || psLANG_CODE || '~' ||
            to_char(length(psTEXT)) || ':' || psTEXT);
      --
        if sql%rowcount = 0
        then
        --
        -- Entity has no existing text items of this type: create new TEXT_TYPE_HEADERS row.
        --
          insert into TEXT_TYPE_HEADERS (TXT_ID, TXTT_CODE, TAB_ALIAS, TXI_SEQ_NBR_MAX)
          values (pnTXT_ID, psTXTT_CODE, sTAB_ALIAS, 1);
        --
          PLS_UTILITY.TRACE_POINT('Inserted TEXT_TYPE_HEADERS');
        --
          pnSEQ_NBR := 1;
        --
        else
          select MULTI_INSTANCE_FLAG
          into sMULTI_INSTANCE_FLAG
          from TEXT_TYPE_PROPERTIES
          where TXTT_CODE = psTXTT_CODE
          and TAB_ALIAS = sTAB_ALIAS;
        --
          if sMULTI_INSTANCE_FLAG = 'N'
          then P_MESSAGE.DISPLAY_MESSAGE('TXT', 7, 'Only one text item of this type allowed');
          end if;
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
          then P_MESSAGE.DISPLAY_MESSAGE('TXT', 8, 'No existing text of this type');
        end;
      --
        if pnSEQ_NBR > nTXI_SEQ_NBR_MAX
        then P_MESSAGE.DISPLAY_MESSAGE('TXT', 9, 'Text item sequence number greater than current maximum');
        end if;
      end if;
    end if;
  --
  -- Create or update TEXT_ITEMS row.
  --
    merge into TEXT_ITEMS TXI
    using
     (select pnTXT_ID TXT_ID, psTXTT_CODE TXTT_CODE, pnSEQ_NBR SEQ_NBR, psLANG_CODE LANG_CODE,
        LONG_TEXT_FLAG
      from TEXT_TYPE_PROPERTIES
      where TXTT_CODE = psTXTT_CODE
      and TAB_ALIAS = sTAB_ALIAS) INP
    on (TXI.TXT_ID = INP.TXT_ID
      and TXI.TXTT_CODE = INP.TXTT_CODE
      and TXI.SEQ_NBR = INP.SEQ_NBR
      and TXI.LANG_CODE = INP.LANG_CODE)
    when matched then
      update
      set TEXT = case when INP.LONG_TEXT_FLAG = 'N' then psTEXT end,
        LONG_TEXT = case when INP.LONG_TEXT_FLAG = 'Y' then psTEXT end
    when not matched then
      insert
       (TXT_ID, TXTT_CODE, SEQ_NBR, LANG_CODE, TAB_ALIAS,
        TEXT,
        LONG_TEXT)
      values
       (pnTXT_ID, psTXTT_CODE, pnSEQ_NBR, psLANG_CODE, sTAB_ALIAS,
        case when INP.LONG_TEXT_FLAG = 'N' then psTEXT end,
        case when INP.LONG_TEXT_FLAG = 'Y' then psTEXT end);
  --
    PLS_UTILITY.TRACE_POINT
     ('Merged TEXT_ITEMS',
      to_char(pnTXT_ID) || '~' || sTAB_ALIAS || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) ||
        '~' || psLANG_CODE || '~' || to_char(length(psTEXT)) || ':' || psTEXT);
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end SET_TEXT;
--
-- ----------------------------------------
-- DELETE_TEXT
-- ----------------------------------------
--
  procedure DELETE_TEXT
   (pnTXT_ID in P_BASE.tnTXT_ID,
    psTXTT_CODE in P_BASE.tsTXTT_CODE := null,
    pnSEQ_NBR in P_BASE.tnTXI_SEQ_NBR := null,
    psLANG_CODE in P_BASE.tsLANG_CODE := null)
  is
    sMANDATORY_FLAG P_BASE.tsTTP_MANDATORY_FLAG;
    nItemCount1 integer;  -- Count of existing text items.
    nItemCount2 integer;  -- Count of text items to be deleted.
  begin
    PLS_UTILITY.START_MODULE
     (sVersion || '-' || sComponent || '.DELETE_TEXT',
      to_char(pnTXT_ID) || '~' || psTXTT_CODE || '~' || to_char(pnSEQ_NBR) || '~' || psLANG_CODE);
  --
  -- Determine if text to be deleted is of a mandatory text type (not necessary if all text is to be
  --  deleted).
  --
    if psTXTT_CODE is not null
    then
      select TTP.MANDATORY_FLAG
      into sMANDATORY_FLAG
      from TEXT_HEADERS TXT
      join TEXT_TYPE_PROPERTIES TTP
        on TTP.TAB_ALIAS = TXT.TAB_ALIAS
        and TTP.TXTT_CODE = psTXTT_CODE
      where TXT.ID = pnTXT_ID;
    end if;
  --
    if psLANG_CODE is not null
    then
    --
    -- Count number of text items existing / to be deleted.
    --
      select count(*), count(case when SEQ_NBR = pnSEQ_NBR and LANG_CODE = psLANG_CODE then 1 end)
      into nItemCount1, nItemCount2
      from TEXT_ITEMS
      where TXT_ID = pnTXT_ID
      and TXTT_CODE = psTXTT_CODE;
    --
      if nItemCount2 = 0
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 10, 'No text to delete');
      end if;
    --
      if nItemCount1 = nItemCount2
      then
      --
      -- Single text item of this type is to be deleted.
      --
        if sMANDATORY_FLAG = 'Y'
        then P_MESSAGE.DISPLAY_MESSAGE('TXT', 11, 'Cannot delete last mandatory text item');
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
    -- Count number of text items existing / to be deleted.
    --
      select count(*), count(case when SEQ_NBR = pnSEQ_NBR then 1 end)
      into nItemCount1, nItemCount2
      from TEXT_ITEMS
      where TXT_ID = pnTXT_ID
      and TXTT_CODE = psTXTT_CODE;
    --
      if nItemCount2 = 0
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 10, 'No text to delete');
      end if;
    --
      if nItemCount1 = nItemCount2
      then
      --
      -- All text items of this type are to be deleted.
      --
        if sMANDATORY_FLAG = 'Y'
        then P_MESSAGE.DISPLAY_MESSAGE('TXT', 11, 'Cannot delete last mandatory text item');
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
      if sMANDATORY_FLAG = 'Y'
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 12, 'Cannot delete mandatory text type');
      end if;
    --
    -- Subordinate TEXT_ITEMS rows will be cascade deleted.
    --
      delete from TEXT_TYPE_HEADERS where TXT_ID = pnTXT_ID and TXTT_CODE = psTXTT_CODE;
    --
      PLS_UTILITY.TRACE_POINT('Deleted TEXT_TYPE_HEADERS-C~' || to_char(sql%rowcount));
    --
      if sql%rowcount = 0
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 10, 'No text to delete');
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
      then P_MESSAGE.DISPLAY_MESSAGE('TXT', 10, 'No text to delete');
      end if;
    end if;
  --
    PLS_UTILITY.END_MODULE;
  exception
    when others
    then PLS_UTILITY.END_MODULE;
      raise;
  end DELETE_TEXT;
--
-- =====================================
-- Initialisation
-- =====================================
--
begin
  if sComponent != 'TXT'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 1, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then P_MESSAGE.DISPLAY_MESSAGE('GEN', 2, 'Module version mismatch');
  end if;
--
end P_TEXT;
/

show errors
