

CREATE FUNCTION [dsp].[Formatter_FormatNumeric] (@numberStr TSTRING)
RETURNS TSTRING
AS
BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@numberStr, '*', ''), '-', ''), '_', ''), '/', ''), ' ', ''), '#', '');
END;