CREATE TABLE [dbo].[Setting] (
    [settingId]   INT CONSTRAINT [DF_Setting_settingId] DEFAULT ((1)) NOT NULL,
    [appSetting1] INT CONSTRAINT [DF_Setting_appSetting1] DEFAULT ((0)) NOT NULL,
    [appSetting2] INT CONSTRAINT [DF_Setting_appSetting2] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED ([settingId] ASC)
);

