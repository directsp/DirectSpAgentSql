CREATE FUNCTION [dsp].[Param_isSetOrNotNull] (
	@value SQL_VARIANT
)
RETURNS BIT
AS
BEGIN
	RETURN IIF(@value IS NULL OR dsp.Param_isSet(@value) = 0, 0, 1);
END;