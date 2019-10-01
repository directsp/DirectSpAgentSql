CREATE TABLE [dsp].[LogFilterSetting] (
    [logFilterSettingId] INT             IDENTITY (1, 1) NOT NULL,
    [logUserId]          NVARCHAR (100)  NOT NULL,
    [isExludedFilter]    BIT             CONSTRAINT [DF_LogFilter_isExludedFilter] DEFAULT ((0)) NOT NULL,
    [filter]             NVARCHAR (2000) NULL,
    CONSTRAINT [PK_LogFilterSetting] PRIMARY KEY CLUSTERED ([logFilterSettingId] ASC),
    CONSTRAINT [FK_LogFilterSetting_logUserId] FOREIGN KEY ([logUserId]) REFERENCES [dsp].[LogUser] ([logUserId])
);


GO
ALTER TABLE [dsp].[LogFilterSetting] NOCHECK CONSTRAINT [FK_LogFilterSetting_logUserId];



