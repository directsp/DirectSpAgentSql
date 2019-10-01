CREATE PROC [dsp].[Exception_throwObjectAlreadyExists] @procId INT, @message TSTRING = NULL, @param0 TSTRING = '<notset>', @param1 TSTRING = '<notset>', @param2 TSTRING = '<notset>', @param3 TSTRING = '<notset>'
AS
BEGIN
    DECLARE @exceptionId  INT = dsp.ExceptionId_objectAlreadyExists();
    EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId , @message = @message, @param0 = @param0, @param1 = @param1,
        @param2 = @param2, @param3 = @param3;
END;