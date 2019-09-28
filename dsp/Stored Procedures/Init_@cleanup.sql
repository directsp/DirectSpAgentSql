CREATE PROCEDURE dsp.Init_@cleanup
    @isProductionEnvironment BIT OUT, @isWithCleanup BIT OUT
AS
BEGIN
    -- Set isProductionEnvironment after creating Setting and Initializing Exceptions and Strings 
    DECLARE @oldIsProductionEnvironment INT;
    EXEC dsp.Setting_props @isProductionEnvironment = @oldIsProductionEnvironment OUTPUT;

    -- Find isProductionEnvironment and IsWithCleanup default depending of current state
    SET @isProductionEnvironment = ISNULL(@isProductionEnvironment, @oldIsProductionEnvironment); -- Don't change isProductionEnvironment if it is not changed
    IF (@isWithCleanup IS NULL)
        SET @isWithCleanup = IIF(@isProductionEnvironment = 1, 0, 1);

    -- validate arguments    
    IF (@isProductionEnvironment = 0 AND @oldIsProductionEnvironment = 1) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'dsp.Init cannot unset isProductionEnvironment setting!';

    IF (@isProductionEnvironment = 1 AND @isWithCleanup = 1) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'Could not execute Cleanup in production environment!';

    -- Update isProductionEnvironment
    EXEC dsp.Setting_propsSet @isProductionEnvironment = @isProductionEnvironment;

    -- Raise error in production environment if IsWithCleanup is set
    IF (@isWithCleanup = 0) --
        RETURN 0;

    -- Make sure dbo.Init_cleanup has production protection
    DECLARE @tranCount INT = @@TRANCOUNT;
    IF (@tranCount = 0)
        BEGIN TRANSACTION;

    SAVE TRANSACTION Test;
    BEGIN TRY
        EXEC dsp.Setting_propsSet @isProductionEnvironment = 1;
        EXEC dbo.Init_cleanup;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'Could not detect dbo.Init_cleanup protection control for production environment!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION Test;
        IF (@tranCount = 0)
            ROLLBACK TRANSACTION;

        IF (ERROR_NUMBER() = dsp.ExceptionId_general() AND   CHARINDEX('dbo.Init_cleanup protection control', ERROR_MESSAGE()) > 0)
            THROW; -- Show the protection error
    END CATCH;

    -- Read CleanUp
    DECLARE @dataBaseName TSTRING = DB_NAME();
    EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Cleaning "{1}" database of "{0}"', @param0 = @@sERVERNAME, @param1 = @dataBaseName;

    -- CleanUp dspAuth if exists
    IF (dsp.Metadata_objectExists('dspAuth', 'Init_cleanup', 'P') = 1) EXEC sys.sp_executesql @stmt='EXEC dspAuth.Init_cleanup';

    -- Cleanup dbo
    EXEC dbo.Init_cleanup;
END;