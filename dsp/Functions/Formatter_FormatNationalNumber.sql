CREATE FUNCTION [dsp].[Formatter_FormatNationalNumber] (
	@nationalNumber TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @nationalNumber = REPLACE(dsp.Formatter_FormatString(@nationalNumber), '-', '');
	RETURN IIF(ISNUMERIC(@nationalNumber) = 1 AND LEN(@nationalNumber) = 10, @nationalNumber, NULL);
END;