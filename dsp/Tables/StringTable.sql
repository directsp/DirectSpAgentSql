CREATE TABLE [dsp].[StringTable] (
    [stringId]    NVARCHAR (100) NOT NULL,
    [stringValue] NVARCHAR (MAX) NOT NULL,
    [culture]  NVARCHAR (10)  NULL,
    [description] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_StringTable] PRIMARY KEY CLUSTERED ([stringId] ASC)
);

