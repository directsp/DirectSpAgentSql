
CREATE PROC dbo.Init_FillStrings
AS
BEGIN
    SET NOCOUNT ON;

	-- Delclare your application strings here
	INSERT	dsp.StringTable (stringId, stringValue)
	VALUES 
		(N'string1', N'string 1'),
		(N'string2', N'string 2');

END