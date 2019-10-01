CREATE TABLE [dspAuth].[PermissionGroupPermission] (
    [permissionGroupId] SMALLINT NOT NULL,
    [permissionId]      SMALLINT NOT NULL,
    CONSTRAINT [PK_PermissionGroupPermission] PRIMARY KEY CLUSTERED ([permissionGroupId] ASC, [permissionId] ASC),
    CONSTRAINT [FK_PermissionGroupPermission_permissionId] FOREIGN KEY ([permissionId]) REFERENCES [dspAuth].[Permission] ([permissionId]) ON DELETE CASCADE,
    CONSTRAINT [FK_PermissionGroupPermission_permissionGroupId] FOREIGN KEY ([permissionGroupId]) REFERENCES [dspAuth].[PermissionGroup] ([permissionGroupId]) ON DELETE CASCADE
);

