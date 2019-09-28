CREATE PROCEDURE dsp.Log_enable
    @removeAllFilters AS BIT = 0
AS
BEGIN
    SET @removeAllFilters = ISNULL(@removeAllFilters, 0);

	-- Find current status
    DECLARE @isEnabled BIT;
    SELECT  @isEnabled = LU.[isEnabled]
      FROM  dsp.LogUser AS LU
     WHERE  LU.logUserId = SYSTEM_USER;

    -- Set enable flag
    IF (@isEnabled IS NULL)
        INSERT  dsp.LogUser (logUserId, [isEnabled])
        VALUES (SYSTEM_USER, 1);
    ELSE
        UPDATE  dsp.LogUser
           SET  [isEnabled] = 1
         WHERE  logUserId = SYSTEM_USER;

    -- Remove All old filters
    IF (@removeAllFilters = 1)
        EXEC dsp.Log_removeFilter @filter = NULL;

   -- Cache the result
    EXEC sys.sp_set_session_context @key='dsp.Log_isEnabled', @value = 1, @read_only = 0;

    PRINT 'LogSystem> LogSystem has been enabled.';
END;