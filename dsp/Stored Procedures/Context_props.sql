
-- /dsp_suppress:1011
CREATE PROCEDURE dsp.Context_props
    @context TCONTEXT OUT, @appName TSTRING = N'<notset>' OUT, @authUserId TSTRING = N'<notset>' OUT, @userId TUSERID = NULL OUT,
    @audience TSTRING = N'<notset>' OUT, @isCaptcha INT = -1 OUT, @recordCount INT = -1 OUT, @recordIndex INT = -1 OUT, @clientIp TSTRING = N'<notset>' OUT,
    @clientVersion TSTRING = N'<notset>' OUT, @appVersion TSTRING = N'<notset>' OUT, @isReadonlyIntent BIT = NULL OUT, @isInvokedByMidware BIT = NULL OUT,
    @isProduction BIT = NULL OUT, @isBatch BIT = NULL OUT
AS
BEGIN
    SET @context = dsp.Context_@updateSysUsers(@context);

    SET @appName = JSON_VALUE(@context, N'$.appName');
    SET @appVersion = JSON_VALUE(@context, N'$.appVersion');
    SET @authUserId = JSON_VALUE(@context, N'$.authUserId');
    SET @userId = JSON_VALUE(@context, N'$.agentContext.userId');
    SET @audience = JSON_VALUE(@context, N'$.audience');
    SET @isCaptcha = ISNULL(CAST(JSON_VALUE(@context, '$.isCaptcha') AS BIT), 0);
    SET @clientIp = JSON_VALUE(@context, N'$.clientIp');
    SET @clientVersion = JSON_VALUE(@context, N'$.clientVersion');
    SET @isReadonlyIntent = ISNULL(CAST(JSON_VALUE(@context, '$.isReadonlyIntent') AS BIT), 0);
    SET @isInvokedByMidware = IIF(@appVersion IS NOT NULL, 1, 0);
    SET @isProduction = ISNULL(CAST(JSON_VALUE(@context, '$.isProduction') AS BIT), 0);
    SET @isBatch = ISNULL(CAST(JSON_VALUE(@context, '$.isBatch') AS BIT), 0);

    IF ((@recordCount IS NULL OR @recordCount <> -1) OR (@recordIndex IS NULL OR @recordIndex <> -1))
    BEGIN
        SET @recordCount = JSON_VALUE(@context, N'$.recordCount');
        SET @recordIndex = JSON_VALUE(@context, N'$.recordIndex');
        EXEC dsp.Context_@validatePagination @recordCount = @recordCount OUTPUT, @recordIndex = @recordIndex OUTPUT;
    END;

END;