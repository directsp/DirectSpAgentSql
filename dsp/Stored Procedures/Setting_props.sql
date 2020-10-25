CREATE PROCEDURE dsp.Setting_props
    @appName TSTRING = NULL OUT, @appVersion TSTRING = NULL OUT, @systemUserId TUSERID = NULL OUT, @appUserId TUSERID = NULL OUT,
    @isProductionEnvironment BIT = NULL OUT, @paginationDefaultRecordCount INT = NULL OUT, @paginationMaxRecordCount INT = NULL OUT,
    @isUnitTestMode BIT = NULL OUT, @maintenanceMode INT = NULL OUT, @isAutoCleanup BIT = NULL OUT
AS
BEGIN

    DECLARE @settingId AS INT;

    SELECT TOP (1) --
        @settingId = settingId, @appName = appName, --
        @appVersion = appVersion, -- 
        @systemUserId = systemUserId, -- 
        @appUserId = appUserId, -- 
        @appVersion = appVersion, -- 
        @isProductionEnvironment = isProductionEnvironment, --
        @paginationDefaultRecordCount = paginationDefaultRecordCount, --
        @paginationMaxRecordCount = paginationMaxRecordCount, --
        @isUnitTestMode = isUnitTestMode, --
        @maintenanceMode = maintenanceMode, --
        @isAutoCleanup = isAutoCleanup
      FROM  dsp.Setting
     ORDER BY settingId;

    IF (@settingId IS NULL) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'DirectSp has not been initialized! Please run dsp.Init';

END;