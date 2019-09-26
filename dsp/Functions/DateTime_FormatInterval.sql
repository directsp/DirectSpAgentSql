CREATE	FUNCTION [dsp].[DateTime_FormatInterval] (@second BIGINT,
	@format TSTRING)
RETURNS TSTRING
AS
BEGIN
	-- Set default format
	SET @format = ISNULL(@format, N'h:m:s');
	RETURN dsp.DateTime_FormatIntervalMillisecond(@second * 1000, @format);
END;




