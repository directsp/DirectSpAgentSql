
CREATE PROC dbo.Init_FillData
AS
BEGIN
    SET NOCOUNT ON;

	-- TODO: Initialize the app 
	EXEC dsp.Setting_PropsSet @appName = 'MyAppName', @appVersion = '1.0.*';

	-- TODO: A proper SystemUserId must be set here
	EXEC dsp.Setting_PropsSet @SystemUserId = 1; -- 

	-- Initialized startup data if they are not initialized yet
END