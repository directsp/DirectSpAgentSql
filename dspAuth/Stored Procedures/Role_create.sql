CREATE PROC [dspAuth].[Role_create]
    @auditUserId INT, @ownerSecurityDescriptorId BIGINT, @roleName TSTRING, @roleId INT = NULL OUT
AS
BEGIN
	SET @roleId = NULL;

    INSERT  dspAuth.Role (roleName, ownerSecurityDescriptorId, modifiedByUserId)
    VALUES (@roleName, @ownerSecurityDescriptorId, @auditUserId);
    SET @roleId = SCOPE_IDENTITY();

    DECLARE @objectTypeId INT = dspAuth.ObjectType_role();
    EXEC dspAuth.SecurityDescriptor_create @objectId = @roleId, @objectTypeId = @objectTypeId;
END;