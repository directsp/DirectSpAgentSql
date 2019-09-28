CREATE	FUNCTION [dsp].[DateTime_formatInterval] (@second BIGINT,
	@format TSTRING)
RETURNS TSTRING
AS
BEGIN
	-- Set default format
	SET @format = ISNULL(@format, N'h:m:s');
	RETURN dsp.DateTime_formatIntervalMillisecond(@second * 1000, @format);
END;




