CREATE	FUNCTION [dsp].[DateTime_firstNextDayOfWeek] (@nextDay INT)
RETURNS DATETIME
AS
BEGIN
	-- Mon:0, Tue:1, Wed:2, Thr:3, Fri:4, Sat:5, Sun:6
	DECLARE @calculatedTime DATETIME = DATEADD(DAY, (DATEDIFF(DAY, @nextDay, GETDATE()) / 7) * 7 + 7, @nextDay);
	RETURN @calculatedTime;
END;