CREATE PROCEDURE [dspAuth].[SecurityDescriptor_securityDescriptorByObject]
    @objectId BIGINT, @objectTypeId INT, @securityDescriptorId BIGINT = NULL OUT
AS
BEGIN
    SET @securityDescriptorId = NULL;
    SELECT  @securityDescriptorId = SD.securityDescriptorId
      FROM  dspAuth.SecurityDescriptor AS SD
     WHERE  SD.objectTypeId = @objectTypeId AND SD.objectId = @objectId;

    IF (@securityDescriptorId IS NULL) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = 'AccessDeniedOrObjectNotExists';

END;