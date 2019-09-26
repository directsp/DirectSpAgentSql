
--Check if a parameter has been updated or not
CREATE FUNCTION [dsp].[Param_IsChanged] (
	@oldValue SQL_VARIANT,
	@newValue SQL_VARIANT,
	@nullAsNotSet BIT
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(dsp.Param_IsSetBase(@newValue, @nullAsNotSet) = 1 AND dsp.Util_IsEqual(@oldValue, @newValue) = 0, 1, 0);
END;