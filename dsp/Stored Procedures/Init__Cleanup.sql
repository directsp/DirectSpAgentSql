CREATE PROCEDURE [dsp].[Init_$Cleanup]
    @isProductionEnvironment BIT OUT, @isWithCleanup BIT OUT
AS
BEGIN
    -- Set IsProductionEnvironment after creating Setting and Initializing Exceptions and Strings 
    DECLARE @OldIsProductionEnvironment INT;
    EXEC dsp.Setting_Props @IsProductionEnvironment = @OldIsProductionEnvironment OUTPUT;

    -- Find IsProductionEnvironment and IsWithCleanup default depending of current state
    SET @isProductionEnvironment = ISNULL(@isProductionEnvironment, @OldIsProductionEnvironment); -- Don't change IsProductionEnvironment if it is not changed
    IF (@isWithCleanup IS NULL)
        SET @isWithCleanup = IIF(@isProductionEnvironment = 1, 0, 1);

    -- validate arguments    
    IF (@isProductionEnvironment = 0 AND @OldIsProductionEnvironment = 1) --
        EXEC err.ThrowGeneralException @procId = @@PROCID, @message = 'dsp.Init cannot unset IsProductionEnvironment setting!';

    IF (@isProductionEnvironment = 1 AND @isWithCleanup = 1) --
        EXEC err.ThrowGeneralException @procId = @@PROCID, @message = 'Could not execute Cleanup in production environment!';

    -- Update IsProductionEnvironment
    EXEC dsp.Setting_PropsSet @IsProductionEnvironment = @isProductionEnvironment;

    -- Raise error in production environment if IsWithCleanup is set
    IF (@isWithCleanup = 0) --
        RETURN;

    -- Make sure dbo.Init_Cleanup has production protection
    DECLARE @TranCount INT = @@TRANCOUNT;
    IF (@TranCount = 0)
        BEGIN TRANSACTION;

    SAVE TRANSACTION Test;
    BEGIN TRY
        EXEC dsp.Setting_PropsSet @IsProductionEnvironment = 1;
        EXEC dbo.Init_Cleanup;
        EXEC err.ThrowGeneralException @procId = @@PROCID, @message = 'Could not detect dbo.Init_Cleanup protection control for production environment';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION Test;
        IF (@TranCount = 0)
            ROLLBACK TRANSACTION;

        IF (ERROR_NUMBER() = err.GeneralExceptionId() AND   CHARINDEX('dbo.Init_Cleanup protection control', ERROR_MESSAGE()) > 0)
            THROW; -- Show the protection error
    END CATCH;

    -- Read CleanUp
    DECLARE @DataBaseName TSTRING = DB_NAME();
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'Cleaning "{1}" database of "{0}"', @param0 = @@SERVERNAME, @param1 = @DataBaseName;

    -- CleanUp dspAuth if exists
    IF (dsp.Metadata_IsObjectExists('dspAuth', 'Init_Cleanup', 'P') = 1) EXEC ('EXEC dspAuth.Init_Cleanup');

    -- Cleanup dbo
    EXEC dbo.Init_Cleanup;
END;







