CREATE TABLE [dspAuth].[SecurityDescriptorUserPermission] (
    [securityDescriptorId] BIGINT          NOT NULL,
    [userId]               [dbo].[TUSERID] NOT NULL,
    [permissionGroupId]    SMALLINT        NOT NULL,
    [auditUserId]          [dbo].[TUSERID] NOT NULL,
    CONSTRAINT [PK_SecurityDescriptorUserPermission] PRIMARY KEY CLUSTERED ([securityDescriptorId] ASC, [permissionGroupId] ASC, [userId] ASC),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_auditUserId] FOREIGN KEY ([auditUserId]) REFERENCES [dbo].[Users] ([userId]),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_permissionGroupId] FOREIGN KEY ([permissionGroupId]) REFERENCES [dspAuth].[PermissionGroup] ([permissionGroupId]),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_securityDescriptorId] FOREIGN KEY ([securityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId]),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_userId] FOREIGN KEY ([userId]) REFERENCES [dbo].[Users] ([userId])
);


GO
ALTER TABLE [dspAuth].[SecurityDescriptorUserPermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorUserPermission_auditUserId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorUserPermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorUserPermission_permissionGroupId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorUserPermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorUserPermission_securityDescriptorId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorUserPermission] NOCHECK CONSTRAINT [FK_SecurityDescriptorUserPermission_userId];



