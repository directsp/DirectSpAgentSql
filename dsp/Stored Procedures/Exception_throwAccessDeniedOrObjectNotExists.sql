CREATE PROC [dsp].Exception_throwAccessDeniedOrObjectNotExists
    @procId INT, @objectTypeName TSTRING = NULL, @objectId TSTRING = NULL, @message TSTRING = NULL, @param0 TSTRING = '<notset>', @param1 TSTRING = '<notset>',
    @param2 TSTRING = '<notset>', @param3 TSTRING = '<notset>'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @argMessage TSTRING = '{}';
	SET @argMessage = JSON_MODIFY(@argMessage, '$.objectName', @objectTypeName);
	SET @argMessage = JSON_MODIFY(@argMessage, '$.objectId', @objectId);
    IF (@message IS NOT NULL)
        SET @argMessage = JSON_MODIFY(@argMessage, '$.message', @message);

    DECLARE @exceptionId INT = dsp.ExceptionId_accessDeniedOrObjectNotExists();
    EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId, @message = @argMessage, @param0 = @param0, @param1 = @param1, @param2 = @param2,
        @param3 = @param3;
END;