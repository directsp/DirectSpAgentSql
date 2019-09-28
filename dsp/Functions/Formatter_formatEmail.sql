CREATE FUNCTION [dsp].[Formatter_formatEmail] (
	@email TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @email = dsp.Formatter_formatString(@email);
	RETURN IIF(dsp.Validate_isValidEmail(@email) = 1, @email, NULL);
END;