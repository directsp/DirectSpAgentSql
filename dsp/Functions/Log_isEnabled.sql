

CREATE FUNCTION dsp.Log_isEnabled ()
RETURNS BIT
AS
BEGIN
    DECLARE @log_isEnabled BIT = CAST(SESSION_CONTEXT(N'dsp.Log_isEnabled') AS BIT);
    IF (@log_isEnabled IS NOT NULL)
        RETURN @log_isEnabled;

    SELECT  @log_isEnabled = LU.[isEnabled]
      FROM  dsp.LogUser AS LU
     WHERE  LU.logUserId = SYSTEM_USER;

    SET @log_isEnabled = ISNULL(@log_isEnabled, 0);
    EXEC sys.sp_set_session_context @key = 'dsp.Log_isEnabled', @value = @log_isEnabled, @read_only = 0;

    RETURN @log_isEnabled;
END;