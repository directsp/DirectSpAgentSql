﻿-- Stop Logging System but keep settings
CREATE PROCEDURE [dsp].[Log_Disable]
AS
BEGIN
	
	-- Set enable flag
	UPDATE dsp.LogUser SET	[isEnabled] = 0 WHERE [userName] = SYSTEM_USER;
	PRINT 'LogSystem> LogSystem has been disbaled.';

	EXEC sys.sp_set_session_context @key = 'dsp.Log_IsEnabled', @value = 0, @read_only = 0;

END