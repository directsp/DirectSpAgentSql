CREATE PROCEDURE dsp.Context_createSystem
    @systemContext TCONTEXT OUT
AS
BEGIN
    SET @systemContext = dsp.Context_@updateSysUsers('$');
END;