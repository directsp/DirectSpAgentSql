

CREATE FUNCTION dsp.Log_IsEnabled ()
RETURNS BIT
AS
BEGIN
    DECLARE @log_IsEnabled BIT = CAST(SESSION_CONTEXT(N'dsp.Log_IsEnabled') AS BIT);
    IF (@log_IsEnabled IS NOT NULL)
        RETURN @log_IsEnabled;

    SELECT  @log_IsEnabled = LU.[isEnabled]
      FROM  dsp.LogUser AS LU
     WHERE  LU.logUserId = SYSTEM_USER;

    SET @log_IsEnabled = ISNULL(@log_IsEnabled, 0);
    EXEC sys.sp_set_session_context @key = 'dsp.Log_IsEnabled', @value = @log_IsEnabled, @read_only = 0;

    RETURN @log_IsEnabled;
END;