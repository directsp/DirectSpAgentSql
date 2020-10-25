CREATE FUNCTION dsp.Context_@updateSysUsers (@context TCONTEXT)
RETURNS TCONTEXT
BEGIN
    -- set defaults
    IF (@context = '$' OR   @context = '$$')
    BEGIN
        DECLARE @aUserId TSTRING = @context;
        SET @context = dsp.Context_@create();
        SET @context = JSON_MODIFY(@context, '$.authUserId', @aUserId);
        SET @context = JSON_MODIFY(@context, '$.isCaptcha', 1);
    END;

    -- create agentContext if does not exists
    IF (JSON_QUERY(@context, '$.agentContext') IS NULL)
        SET @context = JSON_MODIFY(@context, N'$.agentContext', JSON_QUERY('{}', '$'));

    -- check userId
    DECLARE @userId TSTRING = JSON_VALUE(@context, '$.agentContext.userId');
    IF (@userId = '$' OR @userId IS NULL)
        RETURN JSON_MODIFY(@context, '$.agentContext.userId', dsp.Setting_systemUserId());
    IF (@userId = '$$')
        RETURN JSON_MODIFY(@context, '$.agentContext.userId', dsp.Setting_appUserId());
    IF (@userId IS NOT NULL)
        RETURN @context;

    -- check auth
    DECLARE @authUserId TSTRING = JSON_VALUE(@context, '$.authUserId');
    IF (@authUserId = '$')
        RETURN JSON_MODIFY(@context, '$.agentContext.userId', dsp.Setting_systemUserId());
    IF (@authUserId = '$$')
        RETURN JSON_MODIFY(@context, '$.agentContext.userId', dsp.Setting_appUserId());

    RETURN @context;
END;