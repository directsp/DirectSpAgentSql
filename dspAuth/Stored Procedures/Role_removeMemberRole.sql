
CREATE PROC dspAuth.Role_removeMemberRole
    @auditUserId INT, @roleId INT, @memberRoleId INT
AS
BEGIN
    -- Checking if there is a record for roleId and memberRoleId
    EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Checking if there is a record for roleId: {0} and memberRoleId: {1}', @param0 = @roleId,
        @param1 = @memberRoleId;

    -- update audit for temporal tables
    IF @auditUserId IS NOT NULL
        UPDATE  dspAuth.RoleMemberRole
           SET  modifiedByUserId = @auditUserId
         WHERE  modifiedByUserId <> @auditUserId;

	-- delete the record
    DECLARE @hasRoleMember INT = 0;
    SELECT  @hasRoleMember = 1
      FROM  dspAuth.RoleMemberRole AS RM
     WHERE  RM.roleId = @roleId AND RM.memberRoleId = @memberRoleId;

    IF (@hasRoleMember = 0) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = N'There is no RoleMember with Id: {0} for Role: {1}',
            @param0 = @memberRoleId, @param1 = @roleId;

    DELETE  dspAuth.RoleMemberRole
     WHERE  roleId = @roleId AND memberRoleId = @memberRoleId;
END;