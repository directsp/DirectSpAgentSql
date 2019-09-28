CREATE FUNCTION [dsp].[Formatter_redactCardNumberForDisplay] (@cardNumber TSTRING,
	@isRTL BIT)
RETURNS TSTRING
AS
BEGIN
	SET @cardNumber = dsp.Formatter_formatString(@cardNumber);
	RETURN FORMAT(CAST(RIGHT(@cardNumber, 4) AS INT), IIF(@isRTL = 0, '****-****-****-000#', '000#-****-****-****'));
END;