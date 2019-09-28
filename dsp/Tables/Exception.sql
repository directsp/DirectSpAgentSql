CREATE TABLE [dsp].[Exception] (
    [exceptionId]   INT            NOT NULL,
    [exceptionName] NVARCHAR (100) NOT NULL,
    [stringId]      NVARCHAR (100) NULL,
    [description]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Exception] PRIMARY KEY CLUSTERED ([exceptionId] ASC),
    CONSTRAINT [FK_Exception_stringId] FOREIGN KEY ([stringId]) REFERENCES [dsp].[StringTable] ([stringId])
);

