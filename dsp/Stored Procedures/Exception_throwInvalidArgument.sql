
CREATE	PROC [dsp].[Exception_throwInvalidArgument]
	@procId INT, @argumentName TSTRING, @argumentValue TSTRING, @message TSTRING = NULL, @param0 TSTRING = '<notset>', @param1 TSTRING = '<notset>', @param2 TSTRING = '<notset>', @param3 TSTRING = '<notset>'
AS
BEGIN
	SET NOCOUNT ON;

	-- build exception
	DECLARE @argMessage TSTRING;
	EXEC @argMessage = dsp.Formatter_formatMessage @message = N'{"ArgumentName": "{0}", "ArgumentValue": "{1}"}', @param0 = @argumentName,
		@param1 = @argumentValue;

	IF (@message IS NOT NULL)
		SET @argMessage = JSON_MODIFY(@argMessage, '$.message', @message);

	DECLARE @exceptionId INT = dsp.ExceptionId_invalidArgument();
	DECLARE @exception TJSON;
	EXEC @exception  = dsp.[Exception_createParam4] @procId = @procId, @exceptionId  = @exceptionId, @message = @argMessage, @param0 = @param0, @param1 = @param1, @param2 = @param2,
		@param3 = @param3

	-- throw the exception
	EXEC dsp.Exception_throwJson @exception = @exception;
END;