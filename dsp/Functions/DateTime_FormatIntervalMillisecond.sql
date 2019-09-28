CREATE FUNCTION [dsp].[DateTime_formatIntervalMillisecond] (@millisecond BIGINT,
    @format TSTRING)
RETURNS TSTRING
AS
BEGIN
	-- Set default format
	SET @format = ISNULL(@format, N'h:m:s.t')

	-- Set hour if needed
	IF (CHARINDEX('h', @format) > 0)
	BEGIN
		DECLARE @hours BIGINT = @millisecond / (3600 * 1000);
		SET @format = REPLACE(@format, 'h', FORMAT(@hours, '0#'))
		SET @millisecond = @millisecond - (@hours * 3600 * 1000)
	END
	
	-- Set minute if needed
	IF (CHARINDEX('m', @format) > 0)
	BEGIN
		DECLARE @minutes BIGINT = @millisecond / (60 * 1000);
		SET @format = REPLACE(@format, 'm', FORMAT(@minutes, '0#'))
		SET @millisecond = @millisecond - (@minutes * 60 * 1000)
	END

	-- Set minute if needed
	IF (CHARINDEX('s', @format) > 0)
	BEGIN
		DECLARE @seconds INT = @millisecond / (1 * 1000);
		SET @format = REPLACE(@format, 's', FORMAT(@seconds, '0#'))
		SET @millisecond = @millisecond - (@seconds * 1 * 1000)
	END
    
	-- Set second if needed
	IF (CHARINDEX('t', @format) > 0)
		SET @format = REPLACE(@format, 't', FORMAT(@millisecond, '00#'))

    RETURN @format
END;






