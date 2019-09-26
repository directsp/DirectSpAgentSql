CREATE PROCEDURE [dsp].[Context_CreateSystem]
    @systemContext TCONTEXT OUT
AS
BEGIN
    EXEC dsp.Context_Create @userId = '$', @context = @systemContext OUT, @isCaptcha = 1;
END;