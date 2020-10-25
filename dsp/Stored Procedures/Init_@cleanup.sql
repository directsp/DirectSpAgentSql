CREATE PROCEDURE dsp.Init_@cleanup
    @isProductionEnvironment BIT OUT, @isWithCleanup BIT OUT
AS
BEGIN
    -- Set isProductionEnvironment after creating Setting and Initializing Exceptions and Strings 
    DECLARE @oldIsProductionEnvironment INT;
	DECLARE @oldIsAutoCleanup INT;
    EXEC dsp.Setting_props @isProductionEnvironment = @oldIsProductionEnvironment OUTPUT, @isAutoCleanup = @oldIsAutoCleanup OUT;

    -- Find isProductionEnvironment and IsWithCleanup default depending of current state
    SET @isProductionEnvironment = ISNULL(@isProductionEnvironment, @oldIsProductionEnvironment); -- Don't change isProductionEnvironment if it is not changed
    SET @isWithCleanup = ISNULL(@isWithCleanup, 0);

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

	DECLARE @databaseName TSTRING = DB_NAME();
    EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Cleaning "{1}" database of "{0}"', @param0 = @@SERVERNAME, @param1 = @databaseName;
	EXEC dsp.Init_deleteAllDatabaseRecords @serverName = @@SERVERNAME;

	-- restore IsAutoCleanup
    EXEC dsp.Setting_propsSet @isAutoCleanup = @oldIsAutoCleanup;

END;