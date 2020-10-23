CREATE TABLE [dsp].[Exception] (
    [exceptionId]   INT            NOT NULL,
    [exceptionName] NVARCHAR (100) NOT NULL,
    [stringId]      NVARCHAR (100) NULL,
    [description]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Exception] PRIMARY KEY CLUSTERED ([exceptionId] ASC),
    CONSTRAINT [FK_Exception_stringId] FOREIGN KEY ([stringId]) REFERENCES [dsp].[StringTable] ([stringId])
);


GO
ALTER TABLE [dsp].[Exception] NOCHECK CONSTRAINT [FK_Exception_stringId];


GO
EXECUTE sp_tableoption @TableNamePattern = N'[dsp].[Exception]', @OptionName = N'large value types out of row', @OptionValue = N'1';




GO
ALTER TABLE [dsp].[Exception] NOCHECK CONSTRAINT [FK_Exception_stringId];



