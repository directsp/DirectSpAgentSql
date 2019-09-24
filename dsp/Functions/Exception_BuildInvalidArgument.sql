CREATE	FUNCTION [dsp].[Exception_BuildInvalidArgument] (@procId INT,
	@ArgumentName TSTRING,
	@ArgumentValue TSTRING,
	@message TSTRING = NULL)
RETURNS TSTRING
AS
BEGIN
	DECLARE @ArgMessage TSTRING;
	EXEC @ArgMessage = dsp.Formatter_FormatMessage @message = N'{"ArgumentName": "{0}", "ArgumentValue": "{1}"}', @param0 = @ArgumentName,
		@param1 = @ArgumentValue;

	IF (@message IS NOT NULL)
		SET @ArgMessage = JSON_MODIFY(@ArgMessage, '$.Message', @message);

	DECLARE @exceptionId  INT = 55011; /* err.InvalidArgumentId() */
	RETURN dsp.Exception_BuildMessage(@procId, @exceptionId , @ArgMessage);
END;




