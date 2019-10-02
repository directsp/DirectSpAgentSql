
CREATE PROC dspAuth.Role_removeRoleMember
    @auditUserId INT, @roleId INT, @memberRoleId INT
AS
BEGIN

    -- update audit for temporal table
    UPDATE  dspAuth.RoleMemberRole
       SET  modifiedByUserId = @auditUserId
     WHERE  roleId = @roleId AND memberRoleId = @memberRoleId AND   modifiedByUserId <> @auditUserId;

    -- delete the record
    DELETE  dspAuth.RoleMemberRole
     WHERE  roleId = @roleId AND memberRoleId = @memberRoleId;
END;