CREATE PROCEDURE [dsp].[Setting_props]
    @appName TSTRING = NULL OUT, @appVersion TSTRING = NULL OUT, @systemUserId TUSERID = NULL OUT, @appUserId TUSERID = NULL OUT,
    @isProductionEnvironment BIT = NULL OUT, @paginationDefaultRecordCount INT = NULL OUT, @paginationMaxRecordCount INT = NULL OUT,
    @isUnitTestMode BIT = NULL OUT, @maintenanceMode INT = NULL OUT
AS
BEGIN

    DECLARE @settingId AS INT;

    SELECT --
        @settingId = settingId, @appName = appName, --
        @appVersion = appVersion, -- 
        @systemUserId = systemUserId, -- 
        @appUserId = appUserId, -- 
        @appVersion = appVersion, -- 
        @isProductionEnvironment = isProductionEnvironment, --
        @paginationDefaultRecordCount = paginationDefaultRecordCount, --
        @paginationMaxRecordCount = paginationMaxRecordCount, --
        @isUnitTestMode = isUnitTestMode, --
        @maintenanceMode = maintenanceMode --
      FROM  dsp.Setting;

    IF (@settingId IS NULL) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'DirectSp has not been initialized! Please run dsp.Init';

END;