CREATE FUNCTION [dsp].[Formatter_redactMobileNumber] (@mobileNumber TSTRING)
RETURNS TSTRING
BEGIN
	SET @mobileNumber = dsp.Formatter_formatMobileNumber(@mobileNumber);
	IF (@mobileNumber IS NOT NULL)
		RETURN '*********' + SUBSTRING(@mobileNumber, LEN(@mobileNumber) - 1, 2);

	RETURN NULL;
END;