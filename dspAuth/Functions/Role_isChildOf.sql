CREATE FUNCTION [dspAuth].[Role_isChildOf] (@roleId INT,
    @parentRoleId INT)
RETURNS BIT
AS
BEGIN
    DECLARE @isChild BIT = 0;

    WITH RoleRoles
        AS (SELECT  RM.roleId, RM.memberRoleId
              FROM  dspAuth.RoleMemberRole AS RM
             WHERE  RM.memberRoleId = @roleId
            UNION ALL
            SELECT  RM.roleId, RM.memberRoleId
              FROM  dspAuth.RoleMemberRole AS RM
                    INNER JOIN RoleRoles AS CR ON CR.roleId = RM.memberRoleId)
    SELECT  @isChild = 1
      FROM  RoleRoles
     WHERE  RoleRoles.roleId = @parentRoleId;

    RETURN @isChild;
END;