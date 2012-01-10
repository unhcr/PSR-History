create or replace package body PLS_UTILITY is
--
-- ========================================
-- Private types
-- ========================================
--
-- Array of module names.
--
  type tasModuleName is
  table of varchar2(48)
  index by binary_integer;
--
-- Array of context information.
--
  type tasContext is
  table of varchar2(250)
  index by binary_integer;
--
-- ========================================
-- Private global variables
-- ========================================
--
-- Call stack arrays (module names, context information and trace points).
--
  gasModuleName tasModuleName;
  gasContext tasContext;
  gasTracePoint tasContext;
--
  gi binary_integer := 0; -- Call stack index
--
  gbBacktraceEnabled boolean := false; -- Is backtrace display enabled?
  gbTraceEnabled boolean := false; -- Is trace display enabled?
  gsMatchString varchar2(250); -- Filtering string for trace output
--
  gcsLogDir constant varchar2(30) := 'UDUMP'; -- Name of directory object for log file output.
--
  ghFile utl_file.file_type; -- Log file handle
--
  gsOperation varchar2(100);
  gdOperationStart timestamp with time zone;
--
-- ========================================
-- Private program units
-- ========================================
--
-- ----------------------------------------
-- FORMATTED_MESSAGE
-- ----------------------------------------
--
-- Return a formatted string containing the current module, trace point and context information.
--
  function FORMATTED_MESSAGE
  return varchar2
  is
  begin
    return rtrim(gasModuleName(gi) || '/' || gasTracePoint(gi) || ': ' || gasContext(gi), ': ');
  end FORMATTED_MESSAGE;
--
-- ----------------------------------------
-- TRACE_ENABLED
-- ----------------------------------------
--
-- Return true if tracing is currently enabled for the current module / trace point.
--
  function TRACE_ENABLED
  return boolean
  is
  begin
    return(gbTraceEnabled and FORMATTED_MESSAGE like '%' || gsMatchString || '%');
  end TRACE_ENABLED;
--
-- ========================================
-- Public program units
-- ========================================
--
-- ----------------------------------------
-- START_MODULE
-- ----------------------------------------
--
-- Set module name and initial context at start of module.
--
  procedure START_MODULE
   (psModuleName in varchar2,
    psContext in varchar2 := null)
  is
  begin
    dbms_application_info.read_module(gasModuleName(gi), gasTracePoint(gi));
    gi := gi + 1;
    gasModuleName(gi) := to_char(gi) || '#' || psModuleName;
    gasContext(gi) := substr(psContext, 1, 250);
    gasTracePoint(gi) := 'Entry';
    dbms_application_info.set_module(gasModuleName(gi), 'Entry');
    dbms_application_info.set_client_info(psContext);
  --
    if TRACE_ENABLED
    then dbms_output.put_line(substr(FORMATTED_MESSAGE, 1, 255));
    end if;
  end START_MODULE;
--
-- ----------------------------------------
-- END_MODULE
-- ----------------------------------------
--
-- Restore calling module name and context from stack at end of module.
--
  procedure END_MODULE
  is
  begin
    gasTracePoint(gi) := 'Exit';
    dbms_application_info.set_action('Exit');
  --
    if TRACE_ENABLED
    then dbms_output.put_line(substr(FORMATTED_MESSAGE, 1, 255));
    end if;
  --
    if gi > 0
    then gi := gi - 1;
    end if;
  --
    if gi > 0
    then dbms_application_info.set_module(gasModuleName(gi), gasTracePoint(gi));
      dbms_application_info.set_client_info(gasContext(gi));
    else dbms_application_info.set_module(gasModuleName(gi), null);
    end if;
  end END_MODULE;
--
-- ----------------------------------------
-- TRACE_POINT
-- ----------------------------------------
--
-- Output trace point information (optionally with new context information).
--
  procedure TRACE_POINT
   (psTracePoint in varchar2)
  is
  begin
    gasTracePoint(gi) := psTracePoint;
    dbms_application_info.set_action(psTracePoint);
  --
    if TRACE_ENABLED
    then dbms_output.put_line(substr(FORMATTED_MESSAGE, 1, 255));
    end if;
  end TRACE_POINT;
--
--
  procedure TRACE_POINT
   (psTracePoint in varchar2,
    psContext in varchar2)
  is
  begin
    TRACE_CONTEXT(psContext);
  --
    gasTracePoint(gi) := psTracePoint;
    dbms_application_info.set_action(psTracePoint);
  --
    if TRACE_ENABLED
    then dbms_output.put_line(substr(FORMATTED_MESSAGE, 1, 255));
    end if;
  end TRACE_POINT;
--
-- ----------------------------------------
-- TRACE_CONTEXT
-- ----------------------------------------
--
-- Set tracing context with no output of trace information.
--
  procedure TRACE_CONTEXT
   (psContext in varchar2)
  is
  begin
    gasContext(gi) := substr(psContext, 1, 250);
    dbms_application_info.set_client_info(psContext);
  end TRACE_CONTEXT;
--
-- ----------------------------------------
-- TRACE_EXCEPTION
-- ----------------------------------------
--
-- Handle an exception in a procedure or function with tracing.
-- The exception is re-raised with the tracing information of the current module optionally appended
--  (depending on whether backtrace is enabled) and the module stack is tidied up.
--
  procedure TRACE_EXCEPTION
  is
    sMessage varchar2(2500) :=
      regexp_replace(dbms_utility.format_error_stack, '^ORA-20009: ', '') ||
        case when gbBacktraceEnabled then FORMATTED_MESSAGE end;
  begin
    END_MODULE;
  --
    raise_application_error(-20009, sMessage);
  end TRACE_EXCEPTION;
--
-- ----------------------------------------
-- ENABLE_BACKTRACE
-- ----------------------------------------
--
-- Enable backtrace (error stack) output.
--
  procedure ENABLE_BACKTRACE
  is
  begin
    gbBacktraceEnabled := true;
  end ENABLE_BACKTRACE;
--
-- ----------------------------------------
-- DISABLE_BACKTRACE
-- ----------------------------------------
--
-- Disable backtrace output.
--
  procedure DISABLE_BACKTRACE
  is
  begin
    gbBacktraceEnabled := false;
  end DISABLE_BACKTRACE;
--
-- ----------------------------------------
-- ENABLE_TRACE
-- ----------------------------------------
--
-- Enable trace output (with optional filtering parameter).
--  NB. "set serveroutput on" or similar is also required to see the output.
--
  procedure ENABLE_TRACE
   (psMatchString in varchar2 := null)
  is
  begin
    gbTraceEnabled := true;
    gsMatchString := psMatchString;
  end ENABLE_TRACE;
--
-- ----------------------------------------
-- DISABLE_TRACE
-- ----------------------------------------
--
-- Disable trace output.
--
  procedure DISABLE_TRACE
  is
  begin
    gbTraceEnabled := false;
  end DISABLE_TRACE;
--
-- ----------------------------------------
-- OPEN_LOG
-- ----------------------------------------
--
-- Open a log file, written to the server directory indicated by the designated directory object.
--
  procedure OPEN_LOG
   (psFileName in varchar2,
    pbAppend boolean := false)
  is
  begin
    if pbAppend
    then
      begin
        ghFile := utl_file.fopen(gcsLogDir, psFileName, 'a');
      exception
        when utl_file.invalid_operation
        then ghFile := utl_file.fopen(gcsLogDir, psFileName, 'w');
      end;
    else ghFile := utl_file.fopen(gcsLogDir, psFileName, 'w');
    end if;
  end OPEN_LOG;
--
-- ----------------------------------------
-- CLOSE_LOG
-- ----------------------------------------
--
-- Close the currently open log file.
--
  procedure CLOSE_LOG
  is
  begin
    utl_file.fclose(ghFile);
  end CLOSE_LOG;
--
-- ----------------------------------------
-- LOG
-- ----------------------------------------
--
-- Write a message line to the currently open log file.
--
  procedure LOG
   (psMessage in varchar2)
  is
  begin
    utl_file.put_line(ghFile, psMessage);
    utl_file.fflush(ghFile);
  end LOG;
--
-- ----------------------------------------
-- START_OPERATION
-- ----------------------------------------
--
-- Record the start of a timed operation in the currently open log file.
--
  procedure START_OPERATION
   (psOperation in varchar2)
  is
  begin
    gsOperation := psOperation;
    gdOperationStart := systimestamp;
  --
    utl_file.put_line(ghFile,
                      to_char(gdOperationStart, 'YYYY/MM/DD HH24:MI:SS.FF3') || '> ' ||
                        gsOperation || ' - Start');
    utl_file.fflush(ghFile);
  end START_OPERATION;
--
-- ----------------------------------------
-- END_OPERATION
-- ----------------------------------------
--
-- Record the end of the timed operation in the currently open log file, with optional additional
--  message.
--
  procedure END_OPERATION
   (psMessage in varchar2 := null)
  is
    dDuration interval day(2) to second(3) := systimestamp - gdOperationStart;
  begin
    utl_file.put_line(ghFile,
                      to_char(systimestamp, 'YYYY/MM/DD HH24:MI:SS.FF3') || '> ' || gsOperation ||
                        ': duration ' || to_char(dDuration) ||
                        case when psMessage is not null then ' - ' || psMessage end);
    utl_file.fflush(ghFile);
  end END_OPERATION;
--
-- ========================================
-- Initialisation
-- ========================================
--
begin
  if sModule != 'PLS_UTILITY'
  then raise_application_error(-20000, 'Module name mismatch');
  end if;
--
  if sVersion != 'D0.1'
  then raise_application_error(-20000, 'Module version mismatch');
  end if;
--
end PLS_UTILITY;
/

show errors
