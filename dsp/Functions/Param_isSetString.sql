
-- to check if the @value has been set or not
-- String not set value: <notset>
-- Int not set value: -1
-- datetime not set value: '1753-01-01
CREATE FUNCTION [dsp].[Param_isSetString] (@value TBIGSTRING)
RETURNS BIT
AS
BEGIN
	DECLARE @Value2 TSTRING = @value;
	RETURN dsp.Param_isSet(@Value2);
END;