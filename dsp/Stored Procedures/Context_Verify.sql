﻿CREATE PROCEDURE [dsp].[Context_Verify]
    @context TCONTEXT OUT, @procId INT
AS
BEGIN
    -- Settings
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    DECLARE @appUserId TSTRING;
    DECLARE @systemUserId TSTRING;
    DECLARE @maintenanceMode INT;
    EXEC dsp.Setting_Props @appVersion = @appVersion OUT, @appName = @appName OUT, @appUserId = @appUserId OUT, @systemUserId = @systemUserId OUT,
        @maintenanceMode = @maintenanceMode OUT;

    -- Set SystemContext
    IF (@context = N'$') EXEC dsp.Context_CreateSystem @systemContext = @context OUTPUT;
    IF (@context = N'$$') EXEC dsp.Context_Create @userId = '$$', @context = @context OUT, @isCaptcha = 1;

    -- Context 
    DECLARE @contextAuthUserId TSTRING;
    DECLARE @contextAppName TSTRING;
    DECLARE @contextUserId TSTRING;
    DECLARE @contextInvokerAppVersion TSTRING;
    DECLARE @isReadonlyIntent BIT;
    DECLARE @isInvokedByMidware BIT;
    EXEC dsp.Context_Props @context = @context OUTPUT, @authUserId = @contextAuthUserId OUTPUT, @userId = @contextUserId OUTPUT,
        @appName = @contextAppName OUTPUT, @invokerAppVersion = @contextInvokerAppVersion OUT, @isReadonlyIntent = @isReadonlyIntent OUT,
        @isInvokedByMidware = @isInvokedByMidware OUT;
    DECLARE @contextUserIdOrg TSTRING = @contextUserId;
	DECLARE @exceptionId INT;


    -- Check maintenanceMode
    IF (@isInvokedByMidware = 1)
    BEGIN
        IF (@maintenanceMode = 2) --
		BEGIN
			SET @exceptionId = dsp.ExceptionId_Maintenance();
		    EXEC dsp.Exception_Throw @procId = @procId, @exceptionId = @exceptionId;
		END

        IF (@isReadonlyIntent = 0 AND   (@maintenanceMode = 1 OR dsp.Database_IsReadOnly(DB_NAME()) = 1))
		BEGIN
			SET @exceptionId = dsp.ExceptionId_MaintenanceReadOnly();
		    EXEC dsp.Exception_Throw @procId = @procId, @exceptionId = @exceptionId;
		END
    END;


    -- Validate appName
    IF (@contextAppName IS NULL OR  @contextAppName <> @appName) --
        EXEC dsp.Exception_ThrowGeneral @procId = @procId, @message = N'the app property of context is not valid! appName: {0}; contextAppName: {1}',
            @param0 = @appName, @param1 = @contextAppName;

    -- Check InvokerAppVersion if set
    IF (@contextInvokerAppVersion IS NOT NULL AND   @contextInvokerAppVersion <> @appVersion)
	BEGIN
		SET @exceptionId = dsp.ExceptionId_InvokerAppVersion();
		EXEC dsp.Exception_Throw @procId = @procId, @exceptionId = @exceptionId;
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
            EXEC dsp.Exception_ThrowGeneral @procId = @procId, @message = 'systemUserId has not been initailized';
    END;

    -- Find UserId by AuthUserId
    IF (@contextUserId IS NULL) --
    BEGIN
        IF (@contextAuthUserId = '$$')
            SET @contextUserId = ISNULL(@appUserId, @systemUserId);
        ELSE
            EXEC dbo.User_UserIdByAuthUserId @authUserId = @contextAuthUserId, @userId = @contextUserId OUT;
    END;

    -------------
    -- Update Context if user context
    -------------
    IF (@contextUserIdOrg IS NULL OR @contextUserIdOrg <> @contextUserId) --
        EXEC dsp.Context_PropsSet @context = @context OUTPUT, @userId = @contextUserId, @appVersion = @appVersion;

    -- Call update context
    EXEC dbo.Context_Update @context = @context OUTPUT, @procId = @procId;
END;









