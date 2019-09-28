CREATE	FUNCTION [dsp].[Param_isSet] (@value SQL_VARIANT)
RETURNS BIT
AS
BEGIN
	RETURN	dsp.Param_isSetBase(@value, 0);
END;