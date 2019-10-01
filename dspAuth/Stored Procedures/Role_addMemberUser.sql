

CREATE PROC [dspAuth].[Role_addMemberUser]
    @auditUserId INT, @roleId INT, @userId INT
AS
BEGIN
    BEGIN TRY
        INSERT  dspAuth.RoleMemberUser (roleId, memberUserId, modifiedByUserId)
        VALUES (@roleId, @userId, @auditUserId);
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2627) -- duplicate key error
            EXEC dsp.Exception_throwObjectAlreadyExists @procId = @@PROCID, @message = N'UserId: {0}', @param0 = @userId;
        THROW;
    END CATCH;

END;