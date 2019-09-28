CREATE PROCEDURE dsp.Context_verify
    @context TCONTEXT OUT, @procId INT
AS
BEGIN
    -- Settings
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    DECLARE @appUserId TUSERID;
    DECLARE @systemUserId TUSERID;
    DECLARE @maintenanceMode INT;
    EXEC dsp.Setting_props @appVersion = @appVersion OUT, @appName = @appName OUT, @appUserId = @appUserId OUT, @systemUserId = @systemUserId OUT,
        @maintenanceMode = @maintenanceMode OUT;

    -- Set SystemContext
    IF (@context = N'$') EXEC dsp.Context_createSystem @systemContext = @context OUTPUT;
    IF (@context = N'$$') EXEC dsp.Context_create @userId = '$$', @context = @context OUT, @isCaptcha = 1;

    -- Context 
    DECLARE @contextAuthUserId TSTRING;
    DECLARE @contextAppName TSTRING;
    DECLARE @contextUserId TSTRING;
    DECLARE @contextInvokerAppVersion TSTRING;
    DECLARE @isReadonlyIntent BIT;
    DECLARE @isInvokedByMidware BIT;
    EXEC dsp.Context_props @context = @context OUTPUT, @authUserId = @contextAuthUserId OUTPUT, @userId = @contextUserId OUTPUT,
        @appName = @contextAppName OUTPUT, @invokerAppVersion = @contextInvokerAppVersion OUT, @isReadonlyIntent = @isReadonlyIntent OUT,
        @isInvokedByMidware = @isInvokedByMidware OUT;
    DECLARE @contextUserIdOrg TSTRING = @contextUserId;
	DECLARE @exceptionId INT;


    -- Check maintenanceMode
    IF (@isInvokedByMidware = 1)
    BEGIN
        IF (@maintenanceMode = 2) --
		BEGIN
			SET @exceptionId = dsp.ExceptionId_maintenance();
		    EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId;
		END

        IF (@isReadonlyIntent = 0 AND   (@maintenanceMode = 1 OR dsp.Database_isReadOnly(DB_NAME()) = 1))
		BEGIN
			SET @exceptionId = dsp.ExceptionId_maintenanceReadOnly();
		    EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId;
		END
    END;


    -- Validate appName
    IF (@contextAppName IS NULL OR  @contextAppName <> @appName) --
        EXEC dsp.Exception_throwGeneral @procId = @procId, @message = N'the app property of context is not valid! appName: {0}; contextAppName: {1}',
            @param0 = @appName, @param1 = @contextAppName;

    -- Check InvokerAppVersion if set
    IF (@contextInvokerAppVersion IS NOT NULL AND   @contextInvokerAppVersion <> @appVersion)
	BEGIN
		SET @exceptionId = dsp.ExceptionId_invokerAppVersion();
		EXEC dsp.Exception_throw @procId = @procId, @exceptionId = @exceptionId;
	END

    -------------
    -- Fin UserId for System Accounts
    -------------
    IF (@contextUserId = N'$$')
        SET @contextUserId = ISNULL(@appUserId, N'$');

    IF (@contextUserId = N'$')
    BEGIN
        SET @contextUserId = @systemUserId;
        IF (@contextUserId IS NULL) --
            EXEC dsp.Exception_throwGeneral @procId = @procId, @message = 'systemUserId has not been initailized';
    END;

    -- Find UserId by AuthUserId
    IF (@contextUserId IS NULL) --
    BEGIN
        IF (@contextAuthUserId = '$$')
            SET @contextUserId = ISNULL(@appUserId, @systemUserId);
        ELSE
            EXEC dbo.User_userIdByAuthUserId @authUserId = @contextAuthUserId, @userId = @contextUserId OUT;
    END;

    -------------
    -- Update Context if user context
    -------------
    IF (@contextUserIdOrg IS NULL OR @contextUserIdOrg <> @contextUserId) --
        EXEC dsp.Context_propsSet @context = @context OUTPUT, @userId = @contextUserId, @appVersion = @appVersion;

    -- Call update context
    EXEC dbo.Context_update @context = @context OUTPUT, @procId = @procId;
END;










