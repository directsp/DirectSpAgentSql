
--todo: refactor to String_Format
CREATE FUNCTION [dsp].[Formatter_FormatMessage] (
	@message TSTRING,
	@param0 TSTRING = '<notset>',
	@param1 TSTRING = '<notset>',
	@param2 TSTRING = '<notset>',
	@param3 TSTRING = '<notset>')
RETURNS TSTRING
AS
BEGIN

	-- Validate Params
	SET @param0 = dsp.Formatter_FormatParam(@param0);
	SET @param1 = dsp.Formatter_FormatParam(@param1);
	SET @param2 = dsp.Formatter_FormatParam(@param2);
	SET @param3 = dsp.Formatter_FormatParam(@param3);

	-- Replace Message
	SET @message = dsp.Formatter_FormatString(@message);
	SET @message = REPLACE(@message, '{0}', @param0);
	SET @message = REPLACE(@message, '{1}', @param1);
	SET @message = REPLACE(@message, '{2}', @param2);
	SET @message = REPLACE(@message, '{3}', @param3);

	RETURN @message;

END;






