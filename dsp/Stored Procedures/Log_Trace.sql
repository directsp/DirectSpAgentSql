CREATE PROCEDURE [dsp].[Log_Trace]
    @procId AS INT, @message AS TSTRING, @param0 AS TSTRING = '<notset>', @param1 AS TSTRING = '<notset>', @param2 AS TSTRING = '<notset>',
    @param3 AS TSTRING = '<notset>', @param4 AS TSTRING = '<notset>', @param5 AS TSTRING = '<notset>', @elipse BIT = 1, @isHeader BIT = 0
AS
BEGIN
    -- check is log enbaled (fast)
    DECLARE @log_IsEnabled BIT = CAST(SESSION_CONTEXT(N'dsp.Log_IsEnabled') AS BIT);
    IF (@log_IsEnabled IS NOT NULL AND   @log_IsEnabled = 0)
        RETURN 0;

    -- check is log enbaled
    IF (dsp.Log_IsEnabled() = 0)
        RETURN 0;

    -- Format Message
    DECLARE @msg TSTRING = dsp.Log_FormatMessage2(@procId, @message, @elipse, @param0, @param1, @param2, @param3, @param4, @param5);

    -- Manage header
    IF (@isHeader = 1)
        SET @msg = dsp.String_ReplaceEnter(N'\n-----------------------\n-- ' + @msg + N'\n-----------------------');

    -- Check filter
    IF (dsp.Log_$CheckFilters(@msg) = 0)
        RETURN 0;

    -- Print with Black Color
    -- PRINT @msg;
    RAISERROR(@msg, 0, 1) WITH NOWAIT; -- force to flush the buffer
END;