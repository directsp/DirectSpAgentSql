CREATE PROCEDURE [dsp].[Setting_Props]
    @appName TSTRING = NULL OUT, @appVersion TSTRING = NULL OUT, @systemUserId TSTRING = NULL OUT, @appUserId TSTRING = NULL OUT,
    @isProductionEnvironment BIT = NULL OUT, @paginationDefaultRecordCount INT = NULL OUT, @paginationMaxRecordCount INT = NULL OUT,
    @isUnitTestMode BIT = NULL OUT, @maintenanceMode INT = NULL OUT
AS
BEGIN

    SELECT --
        @appName = appName, --
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

END;