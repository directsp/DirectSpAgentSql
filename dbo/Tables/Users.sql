CREATE TABLE [dbo].[Users] (
    [userId]     [dbo].[TUSERID] NOT NULL,
    [authUserId] CHAR (40)       NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([userId] ASC)
);



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'userId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'/NoFK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Users', @level2type = N'COLUMN', @level2name = N'authUserId';

