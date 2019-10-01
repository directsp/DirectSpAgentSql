CREATE TABLE [dspAuth].[PermissionGroup] (
    [permissionGroupId]   SMALLINT       NOT NULL,
    [permissionGroupName] VARCHAR (100)  NOT NULL,
    [description]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_PermissionGroup] PRIMARY KEY CLUSTERED ([permissionGroupId] ASC)
);

