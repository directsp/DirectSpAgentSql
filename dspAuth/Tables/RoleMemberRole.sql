CREATE TABLE [dspAuth].[RoleMemberRole] (
    [roleId]           INT             NOT NULL,
    [memberRoleId]     INT             NOT NULL,
    [modifiedByUserId] [dbo].[TUSERID] NOT NULL,
    [createdTime]      DATETIME        CONSTRAINT [DF_RoleMember_createdTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RoleMemberRole] PRIMARY KEY CLUSTERED ([roleId] ASC, [memberRoleId] ASC),
    CONSTRAINT [FK_RoleMemberRole_memberRoleId] FOREIGN KEY ([memberRoleId]) REFERENCES [dspAuth].[Role] ([roleId]),
    CONSTRAINT [FK_RoleMemberRole_modifiedByUserId] FOREIGN KEY ([modifiedByUserId]) REFERENCES [dbo].[Users] ([userId]),
    CONSTRAINT [FK_RoleMemberRole_roleId] FOREIGN KEY ([roleId]) REFERENCES [dspAuth].[Role] ([roleId])
);


GO
ALTER TABLE [dspAuth].[RoleMemberRole] NOCHECK CONSTRAINT [FK_RoleMemberRole_memberRoleId];


GO
ALTER TABLE [dspAuth].[RoleMemberRole] NOCHECK CONSTRAINT [FK_RoleMemberRole_modifiedByUserId];


GO
ALTER TABLE [dspAuth].[RoleMemberRole] NOCHECK CONSTRAINT [FK_RoleMemberRole_roleId];




GO



GO



GO





GO
CREATE NONCLUSTERED INDEX [IX_memberRoleId]
    ON [dspAuth].[RoleMemberRole]([memberRoleId] ASC);

