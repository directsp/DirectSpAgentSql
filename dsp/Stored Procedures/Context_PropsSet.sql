CREATE PROC [dsp].[Context_propsSet]
    @context TCONTEXT OUT, @appName TSTRING = N'<notset>', @appVersion TSTRING = N'<notset>', @authUserId TSTRING = N'<notset>', @userId TSTRING = N'<notset>',
    @audience TSTRING = N'<notset>', @isCaptcha BIT = NULL, @recordCount INT = -1, @recordIndex INT = -1, @clientVersion TSTRING = N'<notset>'
AS
BEGIN
    IF (@context IS NULL OR @context = '')
        SET @context = '{}';

    -- manage built-in users
    IF (@userId = N'$' OR   @userId = N'$$')
    BEGIN
        DECLARE @systemUserId TUSERID;
        DECLARE @appUserId TUSERID;
        EXEC dsp.Setting_props @systemUserId = @systemUserId OUT, @appUserId = @appUserId OUT;

        IF (@userId = N'$')
            SET @userId = @systemUserId;

        IF (@userId = N'$$')
            SET @userId = ISNULL(@appUserId, @systemUserId);
    END;

    IF (@appName IS NULL OR @appName <> N'<notset>')
        SET @context = JSON_MODIFY(@context, '$.appName', @appName);

    IF (@appVersion IS NULL OR  @appVersion <> N'<notset>')
        SET @context = JSON_MODIFY(@context, '$.appVersion', @appVersion);

    IF (@authUserId IS NULL OR  @authUserId <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.authUserId', @authUserId);

    IF (@userId IS NULL OR  @userId <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.userId', @userId);

    IF (@audience IS NULL OR @audience <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.audience', @audience);

    -- update InvokeOptions
    IF (JSON_QUERY(@context, N'$.invokeOptions') IS NULL)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions', JSON_QUERY('{}', '$'));

    IF (@isCaptcha IS NOT NULL)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.isCaptcha', @isCaptcha);

    IF (@recordCount IS NULL OR @recordCount <> -1)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.recordCount', @recordCount);

    IF (@recordIndex IS NULL OR @recordIndex <> -1)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.recordIndex', @recordIndex);

    IF (@clientVersion IS NULL OR   @clientVersion <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.clientVersion', @clientVersion);
END;








