CREATE FUNCTION [dsp].[Log_FormatMessage2] (@procId INT,
	@message TSTRING,
	@Elipsis BIT = 0,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>',
	@param4 TSTRING = '<notset>',
	@param5 TSTRING = '<notset>')
RETURNS TSTRING
AS
BEGIN
	SET @Elipsis = ISNULL(@Elipsis, 0);

	-- Validate Params
	SET @param0 = dsp.Formatter_FormatParam(@param0);
	SET @param1 = dsp.Formatter_FormatParam(@param1);
	SET @param2 = dsp.Formatter_FormatParam(@param2);
	SET @param3 = dsp.Formatter_FormatParam(@param3);
	SET @param4 = dsp.Formatter_FormatParam(@param4);
	SET @param5 = dsp.Formatter_FormatParam(@param5);

	-- Replace Message
	SET @message = dsp.Formatter_FormatString(@message);
	SET @message = REPLACE(@message, '{0}', @param0);
	SET @message = REPLACE(@message, '{1}', @param1);
	SET @message = REPLACE(@message, '{2}', @param2);
	SET @message = REPLACE(@message, '{3}', @param3);
	SET @message = REPLACE(@message, '{4}', @param4);
	SET @message = REPLACE(@message, '{5}', @param5);

	IF (@Elipsis = 1)
	BEGIN
		DECLARE @LastString TSTRING = SUBSTRING(@message, LEN(@message), 1);
		IF (@LastString NOT LIKE '[.?!:>;]')
			SET @message = @message + ' ...';
	END;

	-- Set Schema and ProcName
	DECLARE @procName TSTRING = ISNULL(OBJECT_NAME(@procId), '(NoSP)');
	DECLARE @schemaName TSTRING = OBJECT_SCHEMA_NAME(@procId);
	IF (@schemaName IS NOT NULL)
		SET @procName = @schemaName + '.' + @procName;

	-- Format message 
	DECLARE @msg TSTRING = @procName + '> ' + @message;
	RETURN dsp.String_ReplaceEnter(@msg);
END;




















