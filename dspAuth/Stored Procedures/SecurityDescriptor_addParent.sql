CREATE PROC [dspAuth].[SecurityDescriptor_addParent]
    @securityDescriptorId BIGINT, @parentSecurityDescriptorId BIGINT
AS
BEGIN
    -- Checking if the securityDescriptorId is parent of parentSecurityDescriptorId or not
    DECLARE @isParentOf BIT;
    EXEC dspAuth.SecurityDescriptor_isParentOf @securityDescriptorId = @securityDescriptorId, @childSecurityDescriptorId = @parentSecurityDescriptorId,
        @isParentOf = @isParentOf OUT;

    IF (@isParentOf = 1)
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID,
            @message = N'Invalid operation: SecurityDescriptorAddParent;A SecurityDescriptor: {0} has been already added as the child of security Object {1}',
            @param0 = @parentSecurityDescriptorId, @param1 = @securityDescriptorId;

    -- Add SecurityDescriptor to SecurityDescriptorInherit
    BEGIN TRY
        INSERT  dspAuth.SecurityDescriptorParent (securityDescriptorId, parentSecurityDescriptorId)
        VALUES (@securityDescriptorId, @parentSecurityDescriptorId);
    END TRY
    BEGIN CATCH
        IF (ERROR_NUMBER() = 2627 AND   ERROR_MESSAGE() LIKE '%SecurityDescriptor%') -- duplicate unique index error
            EXEC dsp.Exception_throwObjectAlreadyExists @procId = @@PROCID, @message = N'SecurityDescriptor: {0}, ParentSecurityId: {1}',
                @param0 = @securityDescriptorId, @param1 = @parentSecurityDescriptorId;
        THROW;
    END CATCH;
END;