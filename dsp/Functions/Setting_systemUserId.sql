CREATE FUNCTION [dsp].[Setting_systemUserId] ()
RETURNS TUSERID
AS
BEGIN
    RETURN (SELECT TOP (1) S.systemUserId FROM dsp.Setting AS S ORDER BY S.settingId);
END;