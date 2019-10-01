
CREATE PROCEDURE [dspAuth].[Init_cleanup]
AS
BEGIN
    SET NOCOUNT ON;
	
    -- Protect production environment
    EXEC dsp.Util_protectProductionEnvironment;

    DELETE  dspAuth.SecurityDescriptorUserPermission;
    DELETE  dspAuth.SecurityDescriptorRolePermission;
    DELETE  dspAuth.PermissionGroupPermission;
    DELETE  dspAuth.RoleMemberRole;
    DELETE  dspAuth.PermissionGroup;
    DELETE  dspAuth.Permission;
    DELETE  dspAuth.Role;
    DELETE  dspAuth.SecurityDescriptorParent;
    DELETE  dspAuth.SecurityDescriptor;
    DELETE  dspAuth.ObjectType;

    
	DBCC CHECKIDENT('dspAuth.SecurityDescriptor', RESEED, 10000000000);

END;