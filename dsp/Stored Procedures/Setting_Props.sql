CREATE PROCEDURE [dsp].[Setting_Props]
    @appName TSTRING = NULL OUT, @appVersion TSTRING = NULL OUT, @SystemUserId TSTRING = NULL OUT, @AppUserId TSTRING = NULL OUT,
    @IsProductionEnvironment BIT = NULL OUT, @PaginationDefaultRecordCount INT = NULL OUT, @PaginationMaxRecordCount INT = NULL OUT,
    @IsUnitTestMode BIT = NULL OUT, @MaintenanceMode INT = NULL OUT
AS
BEGIN

    SELECT --
        @appName = AppName, --
        @appVersion = AppVersion, -- 
        @SystemUserId = SystemUserId, -- 
        @AppUserId = AppUserId, -- 
        @appVersion = AppVersion, -- 
        @IsProductionEnvironment = IsProductionEnvironment, --
        @PaginationDefaultRecordCount = PaginationDefaultRecordCount, --
        @PaginationMaxRecordCount = PaginationMaxRecordCount, --
        @IsUnitTestMode = IsUnitTestMode, --
        @MaintenanceMode = MaintenanceMode --
      FROM  dsp.Setting;

END;