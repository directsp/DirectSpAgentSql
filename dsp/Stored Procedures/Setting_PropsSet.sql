
CREATE PROC dsp.Setting_propsSet
    @appName TSTRING = N'<notset>', @appVersion TSTRING = N'<notset>', @systemUserId TSTRING = N'<notset>', @appUserId TSTRING = N'<notset>',
    @paginationDefaultRecordCount INT = -1, @paginationMaxRecordCount INT = -1, @isProductionEnvironment INT = -1, @isUnitTestMode INT = -1,
    @confirmServerName TSTRING = NULL, @maintenanceMode INT = -1
AS
BEGIN

    IF (dsp.Param_isSet(@isProductionEnvironment) = 1)
    BEGIN
        -- Verify server name if the isProductionEnvironment is going to unset
        DECLARE @oldIsProductionEnvironment INT;
        EXEC dsp.Setting_props @isProductionEnvironment = @oldIsProductionEnvironment OUTPUT;
        IF (@isProductionEnvironment = 0 AND @oldIsProductionEnvironment = 1) --
            EXEC dsp.Util_verifyServerName @confirmServerName = @confirmServerName;

        -- Update isProductionEnvironment
        UPDATE  dsp.Setting
           SET  isProductionEnvironment = @isProductionEnvironment WHERE 1 = 1;
    END;

    IF (dsp.Param_isSet(@appName) = 1)
        UPDATE  dsp.Setting
           SET  appName = @appName WHERE 1 = 1;

    IF (dsp.Param_isSet(@appVersion) = 1)
    BEGIN
        EXEC dsp.Setting_@increaseAppVersion @appVersion = @appVersion OUTPUT, @forceIncrease = 0;
        IF (@appVersion IS NULL) --
            EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'appVersion contains an invalid value!';
        UPDATE  dsp.Setting
           SET  appVersion = @appVersion WHERE 1 = 1;
    END;

    IF (dsp.Param_isSet(@paginationDefaultRecordCount) = 1)
        UPDATE  dsp.Setting
           SET  paginationDefaultRecordCount = @paginationDefaultRecordCount WHERE 1 = 1;

    IF (dsp.Param_isSet(@paginationMaxRecordCount) = 1)
        UPDATE dsp.Setting
           SET  paginationMaxRecordCount = @paginationMaxRecordCount WHERE 1 = 1;

    IF (dsp.Param_isSet(@isUnitTestMode) = 1)
        UPDATE  dsp.Setting
           SET  isUnitTestMode = @isUnitTestMode WHERE 1 = 1;

    IF (dsp.Param_isSet(@systemUserId) = 1)
        UPDATE  dsp.Setting
           SET  systemUserId = @systemUserId WHERE 1 = 1;

    IF (dsp.Param_isSet(@appUserId) = 1)
        UPDATE  dsp.Setting
           SET  appUserId = @appUserId WHERE 1 = 1;

    IF (dsp.Param_isSet(@maintenanceMode) = 1)
        UPDATE  dsp.Setting
           SET  maintenanceMode = @maintenanceMode WHERE 1 = 1;

END;