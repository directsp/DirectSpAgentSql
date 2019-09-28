
-- Retrieve Application settings
CREATE PROCEDURE dbo.Setting_props
    @appSetting1 INT = -1 OUT, @appSetting2 INT = -1 OUT
AS
BEGIN
	SET NOCOUNT ON;

    SELECT  @appSetting1 = [appSetting1], @appSetting2 = [appSetting2]
      FROM  dbo.Setting;

END;