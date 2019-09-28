create FUNCTION [dsp].[DateTime_hasTimePart] (@time DATETIME)
RETURNS BIT
AS
BEGIN
	RETURN IIF(@time = CAST(@time AS DATE), 0, 1);
END;