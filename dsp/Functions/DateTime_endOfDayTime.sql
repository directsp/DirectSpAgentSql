﻿CREATE FUNCTION [dsp].[DateTime_endOfDayTime] (
	@time DATETIME)
RETURNS DATETIME
AS
BEGIN
	DECLARE @nextDay DATETIME = DATEADD(DAY, 1, CAST(CAST(@time AS DATE) AS DATETIME));
	SET @time = DATEADD(MILLISECOND, -10, @nextDay);

	RETURN @time;
END;