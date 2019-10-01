
CREATE PROC [dspAuth].[Role_removeRoleMember]
	@auditUserId INT, @roleId INT, @memberRoleId INT
AS
BEGIN
	DELETE dspAuth.RoleMemberRole
	WHERE	roleId = @roleId AND memberRoleId = @memberRoleId;
END;