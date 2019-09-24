CREATE PROC [dsp].[Context_PropsSet]
    @context TCONTEXT OUT, @appName TSTRING = N'<notset>', @appVersion TSTRING = N'<notset>', @AuthUserId TSTRING = N'<notset>', @userId TSTRING = N'<notset>',
    @audience TSTRING = N'<notset>', @isCaptcha BIT = NULL, @RecordCount INT = -1, @RecordIndex INT = -1, @ClientVersion TSTRING = N'<notset>'
AS
BEGIN
    IF (@context IS NULL OR @context = '')
        SET @context = '{}';

    -- Fix built-in users
    IF (@userId = N'$' OR   @userId = N'$$')
    BEGIN
        DECLARE @SystemUserId TSTRING;
        DECLARE @AppUserId TSTRING;
        EXEC dsp.Setting_Props @SystemUserId = @SystemUserId OUT, @AppUserId = @AppUserId OUT;

        IF (@userId = N'$')
            SET @userId = @SystemUserId;

        IF (@userId = N'$$')
            SET @userId = ISNULL(@AppUserId, @SystemUserId);
    END;

    IF (@appName IS NULL OR @appName <> N'<notset>')
        SET @context = JSON_MODIFY(@context, '$.appName', @appName);

    IF (@appVersion IS NULL OR  @appVersion <> N'<notset>')
        SET @context = JSON_MODIFY(@context, '$.appVersion', @appVersion);

    IF (@AuthUserId IS NULL OR  @AuthUserId <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.authUserId', @AuthUserId);

    IF (@userId IS NULL OR  @userId <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.userId', @userId);

    IF (@audience IS NULL OR @audience <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.audience', @audience);

    -- update InvokeOptions
    IF (JSON_QUERY(@context, N'$.invokeOptions') IS NULL)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions', JSON_QUERY('{}', '$'));

    IF (@isCaptcha IS NOT NULL)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.isCaptcha', @isCaptcha);

    IF (@RecordCount IS NULL OR @RecordCount <> -1)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.recordCount', @RecordCount);

    IF (@RecordIndex IS NULL OR @RecordIndex <> -1)
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.recordIndex', @RecordIndex);

    IF (@ClientVersion IS NULL OR   @ClientVersion <> N'<notset>')
        SET @context = JSON_MODIFY(@context, N'$.invokeOptions.clientVersion', @ClientVersion);
END;








