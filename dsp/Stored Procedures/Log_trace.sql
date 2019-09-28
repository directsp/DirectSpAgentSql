CREATE PROCEDURE dsp.Log_trace
    @procId AS INT, @message AS TSTRING, @param0 AS TSTRING = '<notset>', @param1 AS TSTRING = '<notset>', @param2 AS TSTRING = '<notset>',
    @param3 AS TSTRING = '<notset>', @param4 AS TSTRING = '<notset>', @param5 AS TSTRING = '<notset>', @elipse BIT = 1, @isHeader BIT = 0
AS
BEGIN
    -- check is log enbaled (fast)
    DECLARE @log_isEnabled BIT = CAST(SESSION_CONTEXT(N'dsp.Log_isEnabled') AS BIT);
    IF (@log_isEnabled IS NOT NULL AND   @log_isEnabled = 0)
        RETURN 0;

    -- check is log enbaled
    IF (dsp.Log_isEnabled() = 0)
        RETURN 0;

    -- Format Message
    DECLARE @msg TSTRING = dsp.Log_formatMessage2(@procId, @message, @elipse, @param0, @param1, @param2, @param3, @param4, @param5);

    -- Manage header
    IF (@isHeader = 1)
        SET @msg = dsp.String_replaceEnter(N'\n-----------------------\n-- ' + @msg + N'\n-----------------------');

    -- Check filter
    IF (dsp.Log_@checkFilters(@msg) = 0)
        RETURN 0;

    -- Print with Black Color
    -- PRINT @msg;
    RAISERROR(@msg, 0, 1) WITH NOWAIT; -- force to flush the buffer
END;