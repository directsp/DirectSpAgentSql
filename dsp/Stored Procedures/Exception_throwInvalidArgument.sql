
CREATE	PROC [dsp].[Exception_throwInvalidArgument]
	@procId INT, @argumentName TSTRING, @argumentValue TSTRING, @message TSTRING = NULL
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
	DECLARE @exception TJSON = dsp.[Exception_create](@procId, @exceptionId, @argMessage);

	-- throw the exception
	EXEC dsp.Exception_throwJson @exception = @exception;
END;