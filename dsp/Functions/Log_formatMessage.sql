CREATE FUNCTION [dsp].[Log_formatMessage] (
	@procId INT,
	@message TSTRING,
	@elipsis BIT = 0,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>')
RETURNS TSTRING
AS
BEGIN
	-- Validate Inputs
	SET @elipsis = ISNULL(@elipsis, 0);

	-- Format Message
	SET @message = dsp.Formatter_formatMessage(@message, @param0, @param1, @param2, @param3);

	-- Put elipsis
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
	RETURN @msg;
END;