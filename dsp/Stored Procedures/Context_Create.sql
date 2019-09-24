CREATE PROCEDURE [dsp].[Context_Create]
    @userId TSTRING, @isCaptcha INT = 0, @context TCONTEXT = NULL OUT
AS
BEGIN
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    EXEC dsp.Setting_Props @appName = @appName OUTPUT, @appVersion = @appVersion OUTPUT;

    SET @context = NULL;
    EXEC dsp.Context_PropsSet @context = @context OUTPUT, @userId = @userId, @appName = @appName, @appVersion = @appVersion, @isCaptcha = @isCaptcha;
END;




