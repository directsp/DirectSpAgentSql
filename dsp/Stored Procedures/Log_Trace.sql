CREATE PROCEDURE [dsp].[Log_Trace]
    @procId AS INT, @message AS TSTRING, @param0 AS TSTRING = '<notset>', @param1 AS TSTRING = '<notset>', @param2 AS TSTRING = '<notset>',
    @param3 AS TSTRING = '<notset>', @param4 AS TSTRING = '<notset>', @param5 AS TSTRING = '<notset>', @elipse BIT = 1, @isHeader BIT = 0
AS
BEGIN
    -- check is log enbaled (fast)
    DECLARE @Log_IsEnabled BIT = CAST(SESSION_CONTEXT(N'dsp.Log_IsEnabled') AS BIT);
    IF (@Log_IsEnabled IS NOT NULL AND   @Log_IsEnabled = 0)
        RETURN 0;

    -- check is log enbaled
    IF (dsp.Log_IsEnabled() = 0)
        RETURN 0;

    -- Format Message
    DECLARE @Msg TSTRING = dsp.Log_FormatMessage2(@procId, @message, @elipse, @param0, @param1, @param2, @param3, @param4, @param5);

    -- Manage header
    IF (@isHeader = 1)
        SET @Msg = dsp.String_ReplaceEnter(N'\n-----------------------\n-- ' + @Msg + N'\n-----------------------');

    -- Check Filter
    IF (dsp.Log_$CheckFilters(@Msg) = 0)
        RETURN 0;

    -- Print with Black Color
    -- PRINT @Msg;
    RAISERROR(@Msg, 0, 1) WITH NOWAIT; -- force to flush the buffer
END;