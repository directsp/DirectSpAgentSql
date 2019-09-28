
CREATE PROC dbo.Init_fillData
AS
BEGIN
    SET NOCOUNT ON;

	-- TODO: Initialize the app 
	EXEC dsp.Setting_propsSet @appName = 'MyAppName', @appVersion = '1.0.*';

	-- TODO: A proper systemUserId must be set here
	--EXEC dsp.Setting_propsSet @systemUserId = 1; -- 

	-- Initialized startup data if they are not initialized yet
END