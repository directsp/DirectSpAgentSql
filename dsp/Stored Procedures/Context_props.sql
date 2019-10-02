
-- /dsp_suppress:1011
CREATE PROCEDURE [dsp].[Context_props]
    @context TCONTEXT OUT, @appName TSTRING = N'<notset>' OUT, @authUserId TSTRING = N'<notset>' OUT, @userId TSTRING = N'<notset>' OUT,
    @audience TSTRING = N'<notset>' OUT, @isCaptcha INT = -1 OUT, @recordCount INT = -1 OUT, @recordIndex INT = -1 OUT,
    @clientVersion TSTRING = N'<notset>' OUT, @invokerAppVersion TSTRING = NULL OUT, @isReadonlyIntent BIT = NULL OUT, @isInvokedByMidware BIT = NULL OUT
AS
BEGIN

    -- General
    IF (@appName IS NULL OR @appName <> N'<notset>')
        SET @appName = JSON_VALUE(@context, N'$.appName');

    IF (@authUserId IS NULL OR  @authUserId <> N'<notset>')
        SET @authUserId = JSON_VALUE(@context, N'$.authUserId');

    IF (@userId IS NULL OR  @userId <> N'<notset>')
        SET @userId = JSON_VALUE(@context, N'$.userId');

    IF (@audience IS NULL OR @audience <> N'<notset>')
        SET @audience = JSON_VALUE(@context, N'$.audience');

    -- InvokeOptions
    DECLARE @invokeOptions TJSON = JSON_QUERY(@context, N'$.invokeOptions');

    IF (@clientVersion IS NULL OR   @clientVersion <> N'<notset>')
        SET @clientVersion = JSON_VALUE(@invokeOptions, N'$.clientVersion');

    IF (@isCaptcha IS NULL OR   @isCaptcha <> -1)
        SET @isCaptcha = ISNULL(CAST(JSON_VALUE(@invokeOptions, '$.isCaptcha') AS BIT), 0);

    IF (@isReadonlyIntent IS NULL OR   @isReadonlyIntent <> -1)
        SET @isReadonlyIntent = ISNULL(CAST(JSON_VALUE(@invokeOptions, '$.isReadonlyIntent') AS BIT), 0);

    IF ((@recordCount IS NULL OR @recordCount <> -1) OR (@recordIndex IS NULL OR @recordIndex <> -1))
    BEGIN
        SET @recordCount = JSON_VALUE(@invokeOptions, N'$.recordCount');
        SET @recordIndex = JSON_VALUE(@invokeOptions, N'$.recordIndex');
        EXEC dsp.Context_@validatePagination @recordCount = @recordCount OUTPUT, @recordIndex = @recordIndex OUTPUT;
    END;

    IF (@invokerAppVersion IS NULL OR   @invokerAppVersion <> -1)
        SET @invokerAppVersion = JSON_VALUE(@invokeOptions, N'$.invokerAppVersion');

	SET @isInvokedByMidware = IIF (@invokerAppVersion IS NOT NULL, 1, 0);

END;