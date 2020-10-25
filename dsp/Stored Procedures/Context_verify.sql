CREATE PROCEDURE dsp.Context_verify
    @context TCONTEXT OUT, @procId INT
AS
BEGIN
    -- Settings
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    DECLARE @maintenanceMode INT;
    DECLARE @isProductionEnvironment BIT;
    EXEC dsp.Setting_props @appVersion = @appVersion OUT, @appName = @appName OUT, 
	@maintenanceMode = @maintenanceMode OUT, @isProductionEnvironment = @isProductionEnvironment OUT;

    -- Context 
    DECLARE @contextAppName TSTRING;
    DECLARE @contextIsProduction BIT;
    DECLARE @contextAppVersion TSTRING;
    DECLARE @isReadonlyIntent BIT;
    DECLARE @isInvokedByMidware BIT;
    EXEC dsp.Context_props @context = @context OUTPUT, @appName = @contextAppName OUTPUT, @appVersion = @contextAppVersion OUT,
        @isReadonlyIntent = @isReadonlyIntent OUT, @isProduction = @contextIsProduction, @isInvokedByMidware = @isInvokedByMidware OUT;

    DECLARE @exceptionId INT;

    -- check IsProductionEnvironment
    IF (@isProductionEnvironment = 1 AND @contextIsProduction = 0)
    BEGIN
        SET @exceptionId = dsp.ExceptionId_general();
        EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId, --
            @message = 'You can not send any request to app in production! You need to set IsProduction first';
    END;

    -- Check maintenanceMode
    IF (@isInvokedByMidware = 1)
    BEGIN
        IF (@maintenanceMode = 2) --
        BEGIN
            SET @exceptionId = dsp.ExceptionId_maintenance();
            EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId;
        END;

        IF (@isReadonlyIntent = 0 AND   (@maintenanceMode = 1 OR dsp.Database_isReadOnly(DB_NAME()) = 1))
        BEGIN
            SET @exceptionId = dsp.ExceptionId_maintenanceReadOnly();
            EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId;
        END;
    END;

    -- Validate appName
    IF (@contextAppName IS NULL OR  @contextAppName <> @appName) --
        EXEC dsp.Exception_throwGeneral @procId = @procId, @message = N'the appName of context is {0}, it must be {1}', @param0 = @contextAppName,
        @param1 = @appName;

    -- Check InvokerAppVersion if set
    IF (@contextAppVersion IS NOT NULL AND  @contextAppVersion <> @appVersion)
    BEGIN
        SET @exceptionId = dsp.ExceptionId_invokerAppVersion();
        EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId;
    END;

    -- Call update context
    EXEC dbo.Context_update @context = @context OUTPUT, @procId = @procId;
END;