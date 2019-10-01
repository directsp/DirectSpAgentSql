CREATE   PROCEDURE [dspAuth].[SecurityDescriptor_addRolePermission]
    @securityDescriptorId BIGINT, @permissionGroupId INT, @roleId INT, @auditUserId INT
AS
BEGIN
    INSERT  dspAuth.SecurityDescriptorRolePermission (securityDescriptorId, roleId, permissionGroupId, auditUserId)
    VALUES (@securityDescriptorId, @roleId, @permissionGroupId, @auditUserId);
END;