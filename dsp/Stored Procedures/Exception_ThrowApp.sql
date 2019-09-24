-- Create Procedure ThrowAppException

CREATE PROCEDURE [dsp].Exception_ThrowApp
	@procId INT = NULL, @exceptionId INT, @message TSTRING = NULL, @param0 TSTRING = '<notset>', @param1 TSTRING = '<notset>', @param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Exception TJSON 
	EXEC @Exception  = dsp.Exception_BuildMessageParam4 @procId = @procId, @exceptionId  = @exceptionId, @message = @message, @param0 = @param0, @param1 = @param1, @param2 = @param2,
		@param3 = @param3
	EXEC dsp.Exception_Throw @exception = @Exception;
END;











