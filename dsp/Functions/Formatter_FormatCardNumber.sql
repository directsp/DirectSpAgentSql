﻿CREATE FUNCTION [dsp].[Formatter_FormatCardNumber] (
	@cardNumber TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @cardNumber = dsp.Formatter_FormatString(@cardNumber);
	SET @cardNumber = REPLACE(@cardNumber, ' ', '');
	SET @cardNumber = REPLACE(@cardNumber, '-', '');
	SET @cardNumber = REPLACE(@cardNumber, '$', '');
	RETURN IIF(ISNUMERIC(@cardNumber) = 1 AND (LEN(@cardNumber) = 16 OR LEN(@cardNumber) = 20), @cardNumber, NULL);
END;