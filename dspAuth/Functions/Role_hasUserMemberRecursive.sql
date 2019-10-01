CREATE FUNCTION [dspAuth].[Role_hasUserMemberRecursive] (@roleId INT,
    @userId INT)
RETURNS BIT
AS
BEGIN
    DECLARE @hasUserMember BIT = 0;

    -- Check if user has role
    SELECT  @hasUserMember = 1
      FROM  dspAuth.RoleMemberUser AS RMU
     WHERE  RMU.roleId = @roleId AND RMU.memberUserId = @userId;

    IF (@hasUserMember = 1)
        RETURN @hasUserMember;

    -- Check if user is member of child roles	
    WITH RoleMembers
        AS (SELECT  R.roleId, R.memberRoleId
              FROM  dspAuth.RoleMemberRole AS R
             WHERE  R.roleId = @roleId
            UNION ALL
            SELECT  RM.roleId, RM.memberRoleId
              FROM  dspAuth.RoleMemberRole AS RM
                    INNER JOIN RoleMembers AS CR ON RM.roleId = CR.memberRoleId)
    SELECT  @hasUserMember = 1
      FROM  RoleMembers AS CR
            INNER JOIN dspAuth.RoleMemberUser AS RMU ON RMU.roleId = CR.memberRoleId
     WHERE  RMU.memberUserId = @userId;

    RETURN @hasUserMember;
END;