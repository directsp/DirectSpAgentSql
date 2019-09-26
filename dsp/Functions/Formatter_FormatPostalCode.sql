CREATE FUNCTION [dsp].[Formatter_FormatPostalCode] (@postalCode TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @postalCode = dsp.Formatter_FormatString(@postalCode);
	RETURN IIF(ISNUMERIC(@postalCode) = 1 AND LEN(@postalCode) = 10, @postalCode, NULL);
END;