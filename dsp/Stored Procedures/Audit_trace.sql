﻿CREATE PROCEDURE [dsp].[Audit_trace]
	@procId AS INT,
	@message AS TSTRING,
	@param0 AS TSTRING = '<notset>',
	@param1 AS TSTRING = '<notset>',
	@param2 AS TSTRING = '<notset>'
AS
BEGIN
	-- Format Message
	EXEC dsp.Log_trace @procId = @procId, @message = @message, @param0 = @param0, @param1 = @param1, @param2 = @param2;
END;