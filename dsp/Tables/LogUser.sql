CREATE TABLE [dsp].[LogUser] (
    [logUserId] NVARCHAR (100) NOT NULL,
    [isEnabled] BIT            CONSTRAINT [DF_LogUser_isEnabled] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LogUser] PRIMARY KEY CLUSTERED ([logUserId] ASC)
);

