CREATE TABLE [dspAuth].[Role] (
    [roleId]                    INT             IDENTITY (1, 1) NOT NULL,
    [roleName]                  NVARCHAR (100)  NOT NULL,
    [ownerSecurityDescriptorId] BIGINT          NOT NULL,
    [modifiedByUserId]          [dbo].[TUSERID] NOT NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([roleId] ASC),
    CONSTRAINT [FK_Role_ownerSecurityDescriptorId] FOREIGN KEY ([ownerSecurityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId]),
    CONSTRAINT [FK_Role_modifiedByUserId] FOREIGN KEY ([modifiedByUserId]) REFERENCES [dbo].[Users] ([userId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ownerSecurityDescriptorId]
    ON [dspAuth].[Role]([ownerSecurityDescriptorId] ASC);

