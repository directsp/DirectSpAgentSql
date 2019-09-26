CREATE FUNCTION [dsp].[Formatter_RedactMobileNumber] (@mobileNumber TSTRING)
RETURNS TSTRING
BEGIN
	SET @mobileNumber = dsp.Formatter_FormatMobileNumber(@mobileNumber);
	IF (@mobileNumber IS NOT NULL)
		RETURN '*********' + SUBSTRING(@mobileNumber, LEN(@mobileNumber) - 1, 2);

	RETURN NULL;
END;