CREATE TABLE [dsp].[LogFilterSetting] (
    [logFilterSettingId] INT             IDENTITY (1, 1) NOT NULL,
    [userName]           NVARCHAR (100)  NOT NULL,
    [isExludedFilter]    BIT             CONSTRAINT [DF_LogFilter_isExludedFilter] DEFAULT ((0)) NOT NULL,
    [filter]         NVARCHAR (2000) NULL,
    CONSTRAINT [PK__LogFilter__7B08B2A3AD695576] PRIMARY KEY CLUSTERED ([logFilterSettingId] ASC),
    CONSTRAINT [FK__LogFilter__UserN__1D13DFA0] FOREIGN KEY ([userName]) REFERENCES [dsp].[LogUser] ([userName])
);

