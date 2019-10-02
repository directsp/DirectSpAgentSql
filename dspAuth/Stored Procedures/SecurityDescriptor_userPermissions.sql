CREATE PROC [dspAuth].[SecurityDescriptor_userPermissions]
    @objectId BIGINT, @objectTypeId INT, @userId INT, @permissions TSTRING = NULL OUT
AS
BEGIN
    -- Fill all permission groups in @permissionGroups
    DECLARE @permissionGroups TABLE (permissionGroupId INT NOT NULL);
    DECLARE @roleId INT;
    DECLARE @permissionGroupId INT;
    SET @permissions = '{}';

    -- Get SecurityDescriptroId
    DECLARE @securityDescriptorId BIGINT;
    EXEC dspAuth.SecurityDescriptor_securityDescriptorByObject @objectId = @objectId, @objectTypeId = @objectTypeId,
        @securityDescriptorId = @securityDescriptorId OUTPUT;

    -- Get all parent of SecurityDescriptor
    DECLARE @securityDescriptor_parents TABLE (securityDescriptorId BIGINT NOT NULL);
    INSERT  @securityDescriptor_parents
    SELECT  SOPG.securityDescriptorId
      FROM  dspAuth.SecurityDescriptor_parents(@securityDescriptorId) AS SOPG;

    -- Getting all of the roles for the SecurityDescriptors
    -- SecurityDescriptor_parents Gets parernts of the SecurityDescriptor including itself
    DECLARE Acl_cursor CURSOR FAST_FORWARD FORWARD_ONLY FORWARD_ONLY LOCAL --
    FOR --
    SELECT  ACL.roleId, ACL.permissionGroupId
      FROM  @securityDescriptor_parents AS SOPG
            INNER JOIN dspAuth.SecurityDescriptorRolePermission AS ACL ON ACL.securityDescriptorId = SOPG.securityDescriptorId;

    OPEN Acl_cursor;

    FETCH NEXT FROM Acl_cursor
     INTO @roleId, @permissionGroupId;

    -- Choose PermissionGroups of roles which user belong to (recursively)
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (dspAuth.Role_hasUserMemberRecursive(@roleId, @userId) = 1)
            INSERT  @permissionGroups (permissionGroupId)
            VALUES (@permissionGroupId);

        FETCH NEXT FROM Acl_cursor
         INTO @roleId, @permissionGroupId;
    END;

    CLOSE Acl_cursor;
    DEALLOCATE Acl_cursor;

    -- Getting permissionGroups of the user which given explicitly
    INSERT  @permissionGroups (permissionGroupId)
    SELECT  DISTINCT ACL.permissionGroupId
      FROM  @securityDescriptor_parents AS SDP
            INNER JOIN dspAuth.SecurityDescriptorUserPermission AS ACL ON ACL.securityDescriptorId = SDP.securityDescriptorId
     WHERE  ACL.userId = @userId;

    -- distinct permissions
    SET @permissions = '[' + (SELECT    STUFF((   SELECT    DISTINCT ',' + dsp.Convert_toString(PGP.permissionId)
                                                    FROM    @permissionGroups AS PG
                                                            INNER JOIN dspAuth.PermissionGroupPermission AS PGP ON PGP.permissionGroupId = PG.permissionGroupId
                                                  FOR XML PATH('')), 1, 1, '') + ']');

END;