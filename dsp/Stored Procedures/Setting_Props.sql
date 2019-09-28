CREATE PROCEDURE [dsp].[Setting_props]
    @appName TSTRING = NULL OUT, @appVersion TSTRING = NULL OUT, @systemUserId TUSERID = NULL OUT, @appUserId TUSERID = NULL OUT,
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