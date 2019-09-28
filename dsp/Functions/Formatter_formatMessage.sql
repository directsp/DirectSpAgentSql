
--todo: refactor to String_format
CREATE FUNCTION [dsp].[Formatter_formatMessage] (
	@message TSTRING,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>')
RETURNS TSTRING
AS
BEGIN

	-- Validate Params
	SET @param0 = dsp.Formatter_formatParam(@param0);
	SET @param1 = dsp.Formatter_formatParam(@param1);
	SET @param2 = dsp.Formatter_formatParam(@param2);
	SET @param3 = dsp.Formatter_formatParam(@param3);

	-- Replace Message
	SET @message = dsp.Formatter_formatString(@message);
	SET @message = REPLACE(@message, '{0}', @param0);
	SET @message = REPLACE(@message, '{1}', @param1);
	SET @message = REPLACE(@message, '{2}', @param2);
	SET @message = REPLACE(@message, '{3}', @param3);

	RETURN @message;

END;