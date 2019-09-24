
CREATE PROC [dsp].[Setting_PropsSet]
    @appName TSTRING = N'<notset>', @appVersion TSTRING = N'<notset>', @SystemUserId TSTRING = N'<notset>', @AppUserId TSTRING = N'<notset>',
    @PaginationDefaultRecordCount INT = -1, @PaginationMaxRecordCount INT = -1, @IsProductionEnvironment INT = -1, @IsUnitTestMode INT = -1,
    @ConfirmServerName TSTRING = NULL, @MaintenanceMode INT = -1
AS
BEGIN

    IF (dsp.Param_IsSet(@IsProductionEnvironment) = 1)
    BEGIN
        -- Verify server name if the IsProductionEnvironment is going to unset
        DECLARE @OldIsProductionEnvironment INT;
        EXEC dsp.Setting_Props @IsProductionEnvironment = @OldIsProductionEnvironment OUTPUT;
        IF (@IsProductionEnvironment = 0 AND @OldIsProductionEnvironment = 1) --
            EXEC dsp.Util_VerifyServerName @ConfirmServerName = @ConfirmServerName;

        -- Update IsProductionEnvironment
        UPDATE  dsp.Setting
           SET  IsProductionEnvironment = @IsProductionEnvironment;
    END;

    IF (dsp.Param_IsSet(@appName) = 1)
        UPDATE  dsp.Setting
           SET  AppName = @appName;

    IF (dsp.Param_IsSet(@appVersion) = 1)
    BEGIN
        EXEC dsp.[Setting_$IncreaseAppVersion] @appVersion = @appVersion OUTPUT, @ForceIncrease = 0;
        IF (@appVersion IS NULL) --
            EXEC err.ThrowGeneralException @procId = @@PROCID, @message = 'AppVersion contains an invalid value!';
        UPDATE  dsp.Setting
           SET  AppVersion = @appVersion;
    END;

    IF (dsp.Param_IsSet(@PaginationDefaultRecordCount) = 1)
        UPDATE  dsp.Setting
           SET  PaginationDefaultRecordCount = @PaginationDefaultRecordCount;

    IF (dsp.Param_IsSet(@PaginationMaxRecordCount) = 1)
        UPDATE  dsp.Setting
           SET  PaginationMaxRecordCount = @PaginationMaxRecordCount;

    IF (dsp.Param_IsSet(@IsUnitTestMode) = 1)
        UPDATE  dsp.Setting
           SET  IsUnitTestMode = @IsUnitTestMode;

    IF (dsp.Param_IsSet(@SystemUserId) = 1)
        UPDATE  dsp.Setting
           SET  SystemUserId = @SystemUserId;

    IF (dsp.Param_IsSet(@AppUserId) = 1)
        UPDATE  dsp.Setting
           SET  AppUserId = @AppUserId;

    IF (dsp.Param_IsSet(@MaintenanceMode) = 1)
        UPDATE  dsp.Setting
           SET  MaintenanceMode = @MaintenanceMode;

END;