
CREATE PROCEDURE dbo.User_UserIdByAuthUserId
    @AuthUserId INT, @userId TSTRING OUT
AS
BEGIN
    SET @userId = NULL;

    -- find the UserId from your own user table
    -- SELECT  @userId = U.UserId FROM  dbo.Users AS U WHERE  U.AuthUserId = @AuthUserId;

    IF (@userId IS NULL)
	BEGIN
		DECLARE @exceptionId INT = dsp.ExceptionId_AuthUserNotFound();
        EXEC dsp.Exception_ThrowApp @procId = @@PROCID, @exceptionId = @exceptionId, @message = 'AuthUserId: {0}', @param0 = @AuthUserId;
	END
END;