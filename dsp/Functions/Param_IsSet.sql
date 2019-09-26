CREATE	FUNCTION [dsp].[Param_IsSet] (@value SQL_VARIANT)
RETURNS BIT
AS
BEGIN
	RETURN	dsp.Param_IsSetBase(@value, 0);
END;