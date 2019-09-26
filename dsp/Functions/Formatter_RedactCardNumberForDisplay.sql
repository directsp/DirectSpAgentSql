CREATE FUNCTION [dsp].[Formatter_RedactCardNumberForDisplay] (@CardNumber TSTRING,
	@isRTL BIT)
RETURNS TSTRING
AS
BEGIN
	SET @CardNumber = dsp.Formatter_FormatString(@CardNumber);
	RETURN FORMAT(CAST(RIGHT(@CardNumber, 4) AS INT), IIF(@isRTL = 0, '****-****-****-000#', '000#-****-****-****'));
END;