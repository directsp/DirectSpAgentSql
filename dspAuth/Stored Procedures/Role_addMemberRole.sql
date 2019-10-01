CREATE PROC [dspAuth].[Role_addMemberRole]
    @auditUserId INT, @roleId INT, @memberRoleId INT
AS
BEGIN
    -- Throw Invalid operation if a role is being added to one of its members
    EXEC dsp.Log_trace @procId = @@PROCID, @message = N'throw Invalid operation if a role is being added to one of its members';
    IF (dspAuth.Role_isChildOf(@roleId, @memberRoleId) = 1 OR   @roleId = @memberRoleId) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = N'Invalid operation: RoleAddMember; A role: {0} can not be added its child: {1}',
            @param0 = @memberRoleId, @param1 = @roleId;

    -- Add member to the role
    EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Add member to the role';
    BEGIN TRY
        INSERT  dspAuth.RoleMemberRole (roleId, memberRoleId, modifiedByUserId)
        VALUES (@roleId, @memberRoleId, @auditUserId);
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2627 AND   ERROR_MESSAGE() LIKE '%RoleMember%') -- duplicate unique index error
            EXEC dsp.Exception_throwObjectAlreadyExists @procId = @@PROCID, @message = N'roleId: {0}', @param0 = @roleId;
        THROW;
    END CATCH;
END;