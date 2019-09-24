CREATE PROCEDURE [dsp].[Context_Props]
    @context TCONTEXT OUT, @appName TSTRING = N'<notset>' OUT, @AuthUserId TSTRING = N'<notset>' OUT, @userId TSTRING = N'<notset>' OUT,
    @audience TSTRING = N'<notset>' OUT, @isCaptcha INT = -1 OUT, @RecordCount INT = -1 OUT, @RecordIndex INT = -1 OUT,
    @ClientVersion TSTRING = N'<notset>' OUT, @MoneyConversionRate FLOAT = -1 OUT, @InvokerAppVersion TSTRING = NULL OUT, @IsReadonlyIntent BIT = NULL OUT, @IsInvokedByMidware BIT = NULL OUT
AS
BEGIN
    -- General
    IF (@appName IS NULL OR @appName <> N'<notset>')
        SET @appName = JSON_VALUE(@context, N'$.AppName');

    IF (@AuthUserId IS NULL OR  @AuthUserId <> N'<notset>')
        SET @AuthUserId = JSON_VALUE(@context, N'$.AuthUserId');

    IF (@userId IS NULL OR  @userId <> N'<notset>')
        SET @userId = JSON_VALUE(@context, N'$.UserId');

    IF (@audience IS NULL OR @audience <> N'<notset>')
        SET @audience = JSON_VALUE(@context, N'$.Audience');

    -- InvokeOptions
    DECLARE @InvokeOptions TJSON = JSON_QUERY(@context, N'$.InvokeOptions');

    IF (@ClientVersion IS NULL OR   @ClientVersion <> N'<notset>')
        SET @ClientVersion = JSON_VALUE(@InvokeOptions, N'$.ClientVersion');

    IF (@MoneyConversionRate IS NULL OR @MoneyConversionRate <> -1)
        SET @MoneyConversionRate = ISNULL(JSON_VALUE(@InvokeOptions, N'$.MoneyConversionRate'), 1);

    IF (@isCaptcha IS NULL OR   @isCaptcha <> -1)
        SET @isCaptcha = ISNULL(CAST(JSON_VALUE(@InvokeOptions, '$.IsCaptcha') AS BIT), 0);

    IF (@IsReadonlyIntent IS NULL OR   @IsReadonlyIntent <> -1)
        SET @IsReadonlyIntent = ISNULL(CAST(JSON_VALUE(@InvokeOptions, '$.IsReadonlyIntent') AS BIT), 0);

    IF ((@RecordCount IS NULL OR @RecordCount <> -1) OR (@RecordIndex IS NULL OR @RecordIndex <> -1))
    BEGIN
        SET @RecordCount = JSON_VALUE(@InvokeOptions, N'$.RecordCount');
        SET @RecordIndex = JSON_VALUE(@InvokeOptions, N'$.RecordIndex');
        EXEC dsp.[Context_$ValidatePagination] @RecordCount = @RecordCount OUTPUT, @RecordIndex = @RecordIndex OUTPUT;
    END;

    IF (@InvokerAppVersion IS NULL OR   @InvokerAppVersion <> -1)
        SET @InvokerAppVersion = JSON_VALUE(@InvokeOptions, N'$.InvokerAppVersion');

	SET @IsInvokedByMidware = IIF (@InvokerAppVersion IS NOT NULL, 1, 0);

END;

















