CREATE FUNCTION [dsp].[Setting_appUserId] ()
RETURNS TUSERID
AS
BEGIN
    RETURN (SELECT TOP (1) S.appUserId FROM dsp.Setting AS S ORDER BY S.settingId);
END;