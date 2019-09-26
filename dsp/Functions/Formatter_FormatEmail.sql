CREATE FUNCTION [dsp].[Formatter_FormatEmail] (
	@email TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @email = dsp.Formatter_FormatString(@email);
	RETURN IIF(dsp.Validate_IsValidEmail(@email) = 1, @email, NULL);
END;