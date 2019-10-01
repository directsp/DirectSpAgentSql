
CREATE PROC [dspAuth].[SecurityDescriptor_create]
    @objectId BIGINT, @objectTypeId INT, @securityDescriptorId BIGINT = NULL OUT
AS
BEGIN
    INSERT  dspAuth.SecurityDescriptor (objectId, objectTypeId)
    VALUES (@objectId, @objectTypeId);

    SET @securityDescriptorId = SCOPE_IDENTITY();
END;