CREATE TABLE [dspAuth].[RoleMemberUser] (
    [roleId]           INT             NOT NULL,
    [memberUserId]     [dbo].[TUSERID] NOT NULL,
    [modifiedByUserId] [dbo].[TUSERID] NOT NULL,
    [createdTime]      DATETIME        CONSTRAINT [DF_RoleUserMember_createdTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RoleUserMember] PRIMARY KEY CLUSTERED ([roleId] ASC, [memberUserId] ASC),
    CONSTRAINT [FK_RoleMemberUser_memberUserId] FOREIGN KEY ([memberUserId]) REFERENCES [dbo].[Users] ([userId]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_RoleMemberUser_modifiedByUserId] FOREIGN KEY ([modifiedByUserId]) REFERENCES [dbo].[Users] ([userId])
);


GO
ALTER TABLE [dspAuth].[RoleMemberUser] NOCHECK CONSTRAINT [FK_RoleMemberUser_memberUserId];




GO
ALTER TABLE [dspAuth].[RoleMemberUser] NOCHECK CONSTRAINT [FK_RoleMemberUser_memberUserId];






GO
CREATE NONCLUSTERED INDEX [IX_memberUserId]
    ON [dspAuth].[RoleMemberUser]([memberUserId] ASC);

