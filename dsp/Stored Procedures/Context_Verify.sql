CREATE PROCEDURE [dsp].[Context_Verify]
    @context TCONTEXT OUT, @procId INT
AS
BEGIN
    -- Settings
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    DECLARE @AppUserId TSTRING;
    DECLARE @SystemUserId TSTRING;
    DECLARE @MaintenanceMode INT;
    EXEC dsp.Setting_Props @appVersion = @appVersion OUT, @appName = @appName OUT, @AppUserId = @AppUserId OUT, @SystemUserId = @SystemUserId OUT,
        @MaintenanceMode = @MaintenanceMode OUT;

    -- Set SystemContext
    IF (@context = N'$') EXEC dsp.Context_CreateSystem @SystemContext = @context OUTPUT;
    IF (@context = N'$$') EXEC dsp.Context_Create @userId = '$$', @context = @context OUT, @isCaptcha = 1;

    -- Context 
    DECLARE @ContextAuthUserId TSTRING;
    DECLARE @ContextAppName TSTRING;
    DECLARE @ContextUserId TSTRING;
    DECLARE @ContextInvokerAppVersion TSTRING;
    DECLARE @IsReadonlyIntent BIT;
    DECLARE @IsInvokedByMidware BIT;
    EXEC dsp.Context_Props @context = @context OUTPUT, @AuthUserId = @ContextAuthUserId OUTPUT, @userId = @ContextUserId OUTPUT,
        @appName = @ContextAppName OUTPUT, @InvokerAppVersion = @ContextInvokerAppVersion OUT, @IsReadonlyIntent = @IsReadonlyIntent OUT,
        @IsInvokedByMidware = @IsInvokedByMidware OUT;
    DECLARE @ContextUserIdOrg TSTRING = @ContextUserId;


    -- Check MaintenanceMode
    IF (@IsInvokedByMidware = 1)
    BEGIN
        IF (@MaintenanceMode = 2) --
            EXEC err.ThrowMaintenance @procId = @@PROCID;

        IF (@IsReadonlyIntent = 0 AND   (@MaintenanceMode = 1 OR dsp.Database_IsReadOnly(DB_NAME()) = 1))
            EXEC err.ThrowMaintenanceReadOnly @procId = @@PROCID;
    END;


    -- Validate AppName
    IF (@ContextAppName IS NULL OR  @ContextAppName <> @appName) --
        EXEC err.ThrowGeneralException @procId = @procId, @message = N'the app property of context is not valid! AppName: {0}; ContextAppName: {1}',
            @param0 = @appName, @param1 = @ContextAppName;

    -- Check InvokerAppVersion if set
    IF (@ContextInvokerAppVersion IS NOT NULL AND   @ContextInvokerAppVersion <> @appVersion)
        EXEC err.ThrowInvokerAppVersion @procId = @procId;

    -------------
    -- Fin UserId for System Accounts
    -------------
    IF (@ContextUserId = N'$$')
        SET @ContextUserId = ISNULL(@AppUserId, N'$');

    IF (@ContextUserId = N'$')
    BEGIN
        SET @ContextUserId = @SystemUserId;
        IF (@ContextUserId IS NULL) --
            EXEC err.ThrowGeneralException @procId = @procId, @message = 'SystemUserId has not been initailized';
    END;

    -- Find UserId by AuthUserId
    IF (@ContextUserId IS NULL) --
    BEGIN
        IF (@ContextAuthUserId = '$$')
            SET @ContextUserId = ISNULL(@AppUserId, @SystemUserId);
        ELSE
            EXEC dbo.User_UserIdByAuthUserId @AuthUserId = @ContextAuthUserId, @userId = @ContextUserId OUT;
    END;

    -------------
    -- Update Context if user context
    -------------
    IF (@ContextUserIdOrg IS NULL OR @ContextUserIdOrg <> @ContextUserId) --
        EXEC dsp.Context_PropsSet @context = @context OUTPUT, @userId = @ContextUserId, @appVersion = @appVersion;

    -- Call update context
    EXEC dbo.Context_Update @context = @context OUTPUT, @procId = @procId;
END;










