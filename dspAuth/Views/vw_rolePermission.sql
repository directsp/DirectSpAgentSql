CREATE   VIEW [dspAuth].[RolePermissionView]
AS 
SELECT P.permissionName, P.permissionId, R.roleId, PG.permissionGroupName AS permissionGroupName, R.ownerSecurityDescriptorId AS securityDescriptorId 
FROM  dspAuth.Role AS R  
    INNER JOIN dspAuth.PermissionGroup AS PG ON PG.permissionGroupId = R.ownerSecurityDescriptorId
    INNER JOIN dspAuth.PermissionGroupPermission AS PGP ON PGP.permissionGroupId = PG.permissionGroupId
    INNER JOIN dspAuth.Permission AS P ON P.permissionId = PGP.permissionId