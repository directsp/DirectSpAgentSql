CREATE FUNCTION [dsp].[Formatter_formatPostalCode] (@postalCode TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @postalCode = dsp.Formatter_formatString(@postalCode);
	RETURN IIF(ISNUMERIC(@postalCode) = 1 AND LEN(@postalCode) = 10, @postalCode, NULL);
END;