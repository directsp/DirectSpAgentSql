﻿CREATE PROC dspAuth.SecurityDescriptor_addUserPermission
    @securityDescriptorId BIGINT, @permissionGroupId INT, @userId INT, @auditUserId INT
AS
BEGIN
    INSERT  dspAuth.SecurityDescriptorUserPermission (securityDescriptorId, userId, permissionGroupId, modifiedByUserId)
    VALUES (@securityDescriptorId, @userId, @permissionGroupId, @auditUserId);
END;