CREATE	FUNCTION [dsp].[Exception_createParam4] (@procId INT,
	@exceptionId  INT,
	@message TSTRING = NULL,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>')
RETURNS TJSON
AS
BEGIN
	-- get exception name and detail
	DECLARE @description TSTRING;
	DECLARE @exceptionName TSTRING;

	SELECT	@description = [description], @exceptionName = [exceptionName]
	FROM	dsp.Exception
	WHERE	[exceptionId] = @exceptionId ;

	-- validate exception Id
	IF (@exceptionName IS NULL)
	BEGIN
		SET @message = 'Inavlid AppExceptionId; exceptionId: {0}';
		SET @param0 = @exceptionId ;
		SET @exceptionId  = dsp.ExceptionId_general();
	END;

	-- Replace Message
	EXEC @message = dsp.Formatter_formatMessage @message = @message, @param0 = @param0, @param1 = @param1, @param2 = @param2, @param3 = @param3;

	-- generate exception
	DECLARE @exception TJSON = '{}';
	SET @exception = JSON_MODIFY(@exception, '$.errorId', @exceptionId );
	SET @exception = JSON_MODIFY(@exception, '$.errorName', @exceptionName);
	IF (@description IS NOT NULL)
		SET @exception = JSON_MODIFY(@exception, '$.errorDescription', @description);
	IF (@description IS NOT NULL)
		SET @exception = JSON_MODIFY(@exception, '$.errorDescription', @description);
	IF (@message IS NOT NULL)
		SET @exception = JSON_MODIFY(@exception, '$.errorMessage', @message);

	-- Set Schema and ProcName
	IF (@procId IS NOT NULL)
	BEGIN
		DECLARE @procName TSTRING = ISNULL(OBJECT_NAME(@procId), '(NoSP)');
		DECLARE @schemaName TSTRING = OBJECT_SCHEMA_NAME(@procId);
		IF (@schemaName IS NOT NULL)
			SET @procName = @schemaName + '.' + @procName;
		SET @exception = JSON_MODIFY(@exception, '$.errorProcName', @procName);
	END;

	RETURN @exception;
END;