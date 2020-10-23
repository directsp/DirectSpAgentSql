CREATE PROCEDURE [dsp].[System_api]
    @api TJSON = NULL OUT
AS
BEGIN
	SET NOCOUNT ON
	
	-- get spInfos
	DECLARE @procInfos TJSON;
    EXEC dsp.Metadata_storeProcedures @procInfos = @procInfos OUTPUT;
	
	-- get system props
	DECLARE @appName TSTRING, @appVersion TSTRING;
	EXEC dsp.Setting_props @appName = @appName OUTPUT, @appVersion = @appVersion OUTPUT;

	-- get create apiInfo
	SET @api = JSON_MODIFY('{}', '$.procInfos', JSON_QUERY(@procInfos, '$'));
	SET @api = JSON_MODIFY(@api, '$.appName', @appName);
	SET @api = JSON_MODIFY(@api, '$.appVersion', @appVersion);

	
END;