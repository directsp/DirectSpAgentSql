CREATE TABLE [dspAuth].[Permission] (
    [permissionId]   SMALLINT       NOT NULL,
    [permissionName] NVARCHAR (100) NOT NULL,
    [description]    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED ([permissionId] ASC),
    CONSTRAINT [IX_permissionName] UNIQUE NONCLUSTERED ([permissionName] ASC)
);

