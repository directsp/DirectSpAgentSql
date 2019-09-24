CREATE PROCEDURE [dsp].[Context_CreateSystem]
    @SystemContext TCONTEXT OUT
AS
BEGIN
    EXEC dsp.Context_Create @userId = '$', @context = @SystemContext OUT, @isCaptcha = 1;
END;