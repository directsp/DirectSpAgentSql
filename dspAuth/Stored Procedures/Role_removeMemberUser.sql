
CREATE PROC [dspAuth].[Role_removeMemberUser]
    @auditUserId INT, @roleId INT, @userId INT
AS
BEGIN
    -- Throw Exception if there is no record corresponding to User and Role
    EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Throw Exception if there is no record corresponding to User and Role';

    IF NOT EXISTS (   SELECT    1
                        FROM    dspAuth.RoleMemberUser AS RM
                       WHERE RM.memberUserId = @userId AND  RM.roleId = @roleId)
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = N'there is no user:{0} in Role: {1}', @param0 = @userId, @param1 = @roleId;

    -- Updating and deleting 
    EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Updating and deleting';

    UPDATE  dspAuth.RoleMemberUser
       SET  modifiedByUserId = @auditUserId
     WHERE  memberUserId = @userId AND  roleId = @roleId;

    DELETE  dspAuth.RoleMemberUser
     WHERE  memberUserId = @userId AND  roleId = @roleId;
END;