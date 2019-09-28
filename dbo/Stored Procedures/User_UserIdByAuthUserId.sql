
CREATE PROCEDURE dbo.User_userIdByAuthUserId
    @authUserId TSTRING, @userId TUSERID OUT
AS
BEGIN
    SET @userId = NULL;

    -- find the UserId from your own user table
    -- SELECT  @userId = U.UserId FROM  dbo.Users AS U WHERE  U.AuthUserId = @authUserId;

    IF (@userId IS NULL)
	BEGIN
		DECLARE @exceptionId INT = dsp.ExceptionId_authUserNotFound();
        EXEC dsp.Exception_throw @procId = @@PROCID, @exceptionId = @exceptionId, @message = 'AuthUserId: {0}', @param0 = @authUserId;
	END
END;