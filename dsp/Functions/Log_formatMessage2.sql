﻿CREATE FUNCTION [dsp].[Log_formatMessage2] (@procId INT,
	@message TSTRING,
	@elipsis BIT = 0,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>',
	@param4 TSTRING = '<notset>',
	@param5 TSTRING = '<notset>')
RETURNS TSTRING
AS
BEGIN
	SET @elipsis = ISNULL(@elipsis, 0);

	-- Validate Params
	SET @param0 = dsp.Formatter_formatParam(@param0);
	SET @param1 = dsp.Formatter_formatParam(@param1);
	SET @param2 = dsp.Formatter_formatParam(@param2);
	SET @param3 = dsp.Formatter_formatParam(@param3);
	SET @param4 = dsp.Formatter_formatParam(@param4);
	SET @param5 = dsp.Formatter_formatParam(@param5);

	-- Replace Message
	SET @message = dsp.Formatter_formatString(@message);
	SET @message = REPLACE(@message, '{0}', @param0);
	SET @message = REPLACE(@message, '{1}', @param1);
	SET @message = REPLACE(@message, '{2}', @param2);
	SET @message = REPLACE(@message, '{3}', @param3);
	SET @message = REPLACE(@message, '{4}', @param4);
	SET @message = REPLACE(@message, '{5}', @param5);

	IF (@elipsis = 1)
	BEGIN
		DECLARE @lastString TSTRING = SUBSTRING(@message, LEN(@message), 1);
		IF (@lastString NOT LIKE '[.?!:>;]')
			SET @message = @message + ' ...';
	END;

	-- Set Schema and ProcName
	DECLARE @procName TSTRING = ISNULL(OBJECT_NAME(@procId), '(NoSP)');
	DECLARE @schemaName TSTRING = OBJECT_SCHEMA_NAME(@procId);
	IF (@schemaName IS NOT NULL)
		SET @procName = @schemaName + '.' + @procName;

	-- Format message 
	DECLARE @msg TSTRING = @procName + '> ' + @message;
	RETURN dsp.String_replaceEnter(@msg);
END;