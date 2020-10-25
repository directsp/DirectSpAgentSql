CREATE PROC dsp.Context_propsSet
    @context TCONTEXT OUT, @appName TSTRING = N'<notset>', @appVersion TSTRING = N'<notset>', @authUserId TSTRING = N'<notset>', @userId TSTRING = N'<notset>',
    @audience TSTRING = N'<notset>', @isCaptcha BIT = NULL, @recordCount INT = -1, @recordIndex INT = -1, @clientVersion TSTRING = N'<notset>'
AS
BEGIN
    SET @context = dsp.Context_@updateSysUsers(@context);

    -- manage built-in users
    IF (@appName IS NULL OR @appName <> N'<notset>')
        SET @context = JSON_MODIFY(@context, '$.appName', @appName);

    IF (@appVersion IS NULL OR  @appVersion <> N'<notset>')
        SET @context = JSON_MODIFY(@context, '$.appVersion', @appVersion);

    IF (@userId IS NULL OR  @userId <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.agentContext.userId', @userId);

    IF (@authUserId IS NULL OR  @authUserId <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.authUserId', @authUserId);

    IF (@audience IS NULL OR @audience <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.audience', @audience);

    IF (@isCaptcha IS NOT NULL)
        SET @context = JSON_MODIFY(@context, N'$.isCaptcha', @isCaptcha);

    IF (@recordCount IS NULL OR @recordCount <> -1)
        SET @context = JSON_MODIFY(@context, N'$.recordCount', @recordCount);

    IF (@recordIndex IS NULL OR @recordIndex <> -1)
        SET @context = JSON_MODIFY(@context, N'$.recordIndex', @recordIndex);

    IF (@clientVersion IS NULL OR   @clientVersion <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.clientVersion', @clientVersion);

    SET @context = dsp.Context_@updateSysUsers(@context);

END;