CREATE PROCEDURE [dsp].[Context_createSystem]
    @systemContext TCONTEXT OUT
AS
BEGIN
    EXEC dsp.Context_create @userId = '$', @context = @systemContext OUT, @isCaptcha = 1;
END;