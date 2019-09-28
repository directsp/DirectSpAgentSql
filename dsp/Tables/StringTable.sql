CREATE TABLE [dsp].[StringTable] (
    [stringId]    NVARCHAR (100) NOT NULL,
    [stringValue] NVARCHAR (MAX) NOT NULL,
    [culture]     NVARCHAR (10)  NULL,
    [description] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_StringTable] PRIMARY KEY CLUSTERED ([stringId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'/NoFK', @level0type = N'SCHEMA', @level0name = N'dsp', @level1type = N'TABLE', @level1name = N'StringTable', @level2type = N'COLUMN', @level2name = N'stringId';

