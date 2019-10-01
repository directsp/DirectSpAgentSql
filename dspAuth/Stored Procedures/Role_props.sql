CREATE PROC [dspAuth].[Role_props]
    @roleId INT, @ownerSecurityDescriptorId BIGINT = NULL OUT, @roleName TSTRING = NULL OUT
AS
BEGIN
    SELECT  @roleName = R.roleName, @ownerSecurityDescriptorId = R.ownerSecurityDescriptorId
      FROM  dspAuth.Role AS R
     WHERE  R.roleId = @roleId;

    IF (@ownerSecurityDescriptorId IS NULL) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = 'roleId: {0}', @param0 = @roleId;
END;