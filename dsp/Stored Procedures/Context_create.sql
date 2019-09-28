CREATE PROCEDURE [dsp].[Context_create]
    @userId TSTRING, @isCaptcha INT = 0, @context TCONTEXT = NULL OUT
AS
BEGIN
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    EXEC dsp.Setting_props @appName = @appName OUTPUT, @appVersion = @appVersion OUTPUT;

    SET @context = NULL;
    EXEC dsp.Context_propsSet @context = @context OUTPUT, @userId = @userId, @appName = @appName, @appVersion = @appVersion, @isCaptcha = @isCaptcha;
END;