CREATE PROCEDURE [dspAuth].[Role_propsSet]
    @auditUserId INT, @roleId INT, @roleName TSTRING = '<notset>'
AS
BEGIN
    -- Fetch Old Data
    DECLARE @oldRoleName TSTRING;
    SELECT  @oldRoleName = R.roleName
      FROM  dspAuth.Role AS R
     WHERE  R.roleId = @roleId;

    -- Detect if there are any changes
    DECLARE @isUserUpdated BIT = 0;
    EXEC dsp.SetIfChanged_string @procId = @@PROCID, @propName = 'roleName', @isUpdated = @isUserUpdated OUT, @oldValue = @oldRoleName OUT,
        @newValue = @roleName;

    -- Update table Role if neccassary
    IF (@isUserUpdated = 1)
        UPDATE  dspAuth.Role
           SET  roleName = @oldRoleName, modifiedByUserId = @auditUserId
         WHERE  roleId = @roleId;
END;