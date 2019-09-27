CREATE TABLE [dsp].[Setting] (
    [settingId]                    INT             NOT NULL,
    [appName]                      NVARCHAR (50)   CONSTRAINT [DF_Setting_appName] DEFAULT (N'NewApplicationName') NOT NULL,
    [appVersion]                   VARCHAR (50)    CONSTRAINT [DF_Setting_appVersion] DEFAULT ('1.0.0') NOT NULL,
    [isUnitTestMode]               BIT             CONSTRAINT [DF_Setting_isUnitTestMode] DEFAULT ((0)) NOT NULL,
    [isProductionEnvironment]      BIT             CONSTRAINT [DF_Setting_isProductionEnvironment] DEFAULT ((0)) NOT NULL,
    [paginationDefaultRecordCount] INT             CONSTRAINT [DF_Setting_paginationDefaultRecordCount] DEFAULT ((50)) NOT NULL,
    [paginationMaxRecordCount]     INT             CONSTRAINT [DF_Setting_paginationMaxRecordCount] DEFAULT ((200)*(1000000)) NOT NULL,
    [appUserId]                    [dbo].[TUSERID] NULL,
    [systemUserId]                 [dbo].[TUSERID] NULL,
    [maintenanceMode]              TINYINT         CONSTRAINT [DF_Setting_maintenanceMode] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED ([settingId] ASC),
    CONSTRAINT [CK_Setting_maintenaceMode] CHECK ([maintenanceMode]=(2) OR [maintenanceMode]=(1) OR [maintenanceMode]=(0)),
    CONSTRAINT [FK_Setting_appUserId] FOREIGN KEY ([appUserId]) REFERENCES [dbo].[Users] ([userId]),
    CONSTRAINT [FK_Setting_systemUserId] FOREIGN KEY ([systemUserId]) REFERENCES [dbo].[Users] ([userId])
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Midware uses this userId if it is set otherwise the midware use systemUserId', @level0type = N'SCHEMA', @level0name = N'dsp', @level1type = N'TABLE', @level1name = N'Setting', @level2type = N'COLUMN', @level2name = N'appUserId';

