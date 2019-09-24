CREATE FUNCTION [dsp].[Log_FormatMessage] (
	@procId INT,
	@message TSTRING,
	@Elipsis BIT = 0,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>')
RETURNS TSTRING
AS
BEGIN
	-- Validate Inputs
	SET @Elipsis = ISNULL(@Elipsis, 0);

	-- Format Message
	SET @message = dsp.Formatter_FormatMessage(@message, @param0, @param1, @param2, @param3);

	-- Put Elipsis
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
	RETURN @msg;
END;