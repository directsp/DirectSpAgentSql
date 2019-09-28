CREATE FUNCTION [dsp].[Formatter_formatParam] (@param TSTRING)
RETURNS TSTRING
AS
BEGIN
	-- return nothing has been set
	IF (dsp.Param_isSetString(@param) = 0)
		RETURN '<notset>';

	-- set <null> string for NULL to indicate the value is null
	RETURN ISNULL(@param, '<null>');
END;