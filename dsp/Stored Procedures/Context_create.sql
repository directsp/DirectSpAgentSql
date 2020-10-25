CREATE PROCEDURE dsp.Context_create
    @userId TSTRING, @isCaptcha INT = 0, @context TCONTEXT = NULL OUT
AS
BEGIN
    SET @context = dsp.Context_@create();
    EXEC dsp.Context_propsSet @context = @context OUTPUT, @userId = @userId, @isCaptcha = @isCaptcha;
END;