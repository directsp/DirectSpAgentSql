CREATE TABLE [dsp].[LogUser] (
    [userName]  NVARCHAR (100) NOT NULL,
    [isEnabled] BIT            CONSTRAINT [DF_LogUser_isEnabled] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__LogUser] PRIMARY KEY CLUSTERED ([userName] ASC)
);

