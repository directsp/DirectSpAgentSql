
-- Retrieve Application settings
CREATE PROCEDURE dbo.Setting_PropsSet
    @appSetting1 INT = -1, @appSetting2 INT = -1
AS
BEGIN
    SET NOCOUNT ON;

    IF (dsp.Param_IsSet(@appSetting1) = 1)
        UPDATE  dbo.Setting
           SET  [appSetting1] = @appSetting1 WHERE 1 = 1;

    IF (dsp.Param_IsSet(@appSetting2) = 2)
        UPDATE  dbo.Setting
           SET  [appSetting2] = @appSetting2 WHERE 1 = 1;
END;