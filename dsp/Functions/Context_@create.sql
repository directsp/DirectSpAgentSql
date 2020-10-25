CREATE FUNCTION dsp.Context_@create ()
RETURNS TCONTEXT
BEGIN
    DECLARE @appName TSTRING;
    DECLARE @appVersion TSTRING;
    SELECT  @appName = appName, @appVersion = appVersion
      FROM  dsp.Setting;

    DECLARE @context TCONTEXT = '{}';
    SET @context = JSON_MODIFY(@context, '$.appName', @appName);
    SET @context = JSON_MODIFY(@context, '$.appVersion', @appVersion);
    RETURN @context;
END;