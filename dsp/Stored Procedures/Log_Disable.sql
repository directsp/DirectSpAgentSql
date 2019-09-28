-- Stop Logging System but keep settings
CREATE PROCEDURE dsp.Log_disable
AS
BEGIN
	
	-- Set enable flag
	UPDATE dsp.LogUser SET	[isEnabled] = 0 WHERE logUserId = SYSTEM_USER;
	PRINT 'LogSystem> LogSystem has been disbaled.';

	EXEC sys.sp_set_session_context @key = 'dsp.Log_isEnabled', @value = 0, @read_only = 0;

END