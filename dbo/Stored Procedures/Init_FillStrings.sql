
CREATE PROC dbo.Init_FillStrings
AS
BEGIN
    SET NOCOUNT ON;

	-- Delclare your application strings here
	INSERT	dsp.StringTable (StringId, StringValue)
	VALUES 
		(N'String1', N'string 1'),
		(N'String2', N'string 2');

END