CREATE TABLE [dspAuth].[RoleMemberRole] (
    [roleId]           INT             NOT NULL,
    [memberRoleId]     INT             NOT NULL,
    [modifiedByUserId] [dbo].[TUSERID] NOT NULL,
    [createdTime]      DATETIME        CONSTRAINT [DF_RoleMember_createdTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RoleMember] PRIMARY KEY CLUSTERED ([roleId] ASC, [memberRoleId] ASC),
    CONSTRAINT [FK_RoleMember_roleId] FOREIGN KEY ([roleId]) REFERENCES [dspAuth].[Role] ([roleId]),
    CONSTRAINT [FK_RoleMember_memberRoleId] FOREIGN KEY ([memberRoleId]) REFERENCES [dspAuth].[Role] ([roleId]),
    CONSTRAINT [FK_RoleMember_userId] FOREIGN KEY ([modifiedByUserId]) REFERENCES [dbo].[Users] ([userId])
);


GO
CREATE NONCLUSTERED INDEX [IX_memberRoleId]
    ON [dspAuth].[RoleMemberRole]([memberRoleId] ASC);

