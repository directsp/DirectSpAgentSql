CREATE TABLE [dspAuth].[SecurityDescriptorUserPermission] (
    [securityDescriptorId] BIGINT   NOT NULL,
    [UserId]               [dbo].[TUSERID]      NOT NULL,
    [permissionGroupId]    SMALLINT NOT NULL,
    [auditUserId]          [dbo].[TUSERID]      NOT NULL,
    CONSTRAINT [PK_SecurityDescriptorUserPermission] PRIMARY KEY CLUSTERED ([securityDescriptorId] ASC, [permissionGroupId] ASC, [UserId] ASC),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_permissionGroupId] FOREIGN KEY ([permissionGroupId]) REFERENCES [dspAuth].[PermissionGroup] ([permissionGroupId]),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_securityDescriptorId] FOREIGN KEY ([securityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId]),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_userId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([userId]),
    CONSTRAINT [FK_SecurityDescriptorUserPermission_auditUserId] FOREIGN KEY ([auditUserId]) REFERENCES [dbo].[Users] ([userId])
);

