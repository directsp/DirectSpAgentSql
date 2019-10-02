CREATE TABLE [dspAuth].[SecurityDescriptorRolePermission] (
    [securityDescriptorId] BIGINT          NOT NULL,
    [roleId]               INT             NOT NULL,
    [permissionGroupId]    SMALLINT        NOT NULL,
    [modifiedByUserId]     [dbo].[TUSERID] NOT NULL,
    [createdTime]          DATETIME        CONSTRAINT [DF_SecurityDescriptorRolePermission_createdTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SecurityDescriptorRolePermission] PRIMARY KEY CLUSTERED ([securityDescriptorId] ASC, [roleId] ASC, [permissionGroupId] ASC),
    CONSTRAINT [FK_SecurityDescriptorRolePermission_modifiedByUserId] FOREIGN KEY ([modifiedByUserId]) REFERENCES [dbo].[Users] ([userId]),
    CONSTRAINT [FK_SecurityDescriptorRolePermission_permissionGroupId] FOREIGN KEY ([permissionGroupId]) REFERENCES [dspAuth].[PermissionGroup] ([permissionGroupId]),
    CONSTRAINT [FK_SecurityDescriptorRolePermission_roleId] FOREIGN KEY ([roleId]) REFERENCES [dspAuth].[Role] ([roleId]),
    CONSTRAINT [FK_SecurityDescriptorRolePermission_securityDescriptorId] FOREIGN KEY ([securityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId])
);


GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_modifiedByUserId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_permissionGroupId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_roleId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_securityDescriptorId];




GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_permissionGroupId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_roleId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorRolePermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorRolePermission_securityDescriptorId];


GO




