
CREATE FUNCTION [dsp].[Metadata_StoreProcedureAnnotation]
(
  @storeProcedureName TSTRING
)
RETURNS TSTRING
AS
BEGIN
	--format: 
	/*
	#MetaStart 
		{
			"dataAccessMode": "write|readSync|readSnapshot|readWise", 
			"commandTimeout": -1,
			"isBatchAllowed": false, 
			"captchaMode": "manual|always|auto",
			"params": {"paramName": {"paramAttr1": value1, "paramAttr2": value2}},
			"fields": {"fieldName": {"fieldAttr1": value1, "paramAttr2": value2}}
		} 
	#MetaEnd 
	*/
	
	-- Get script
    DECLARE @script TSTRING;
    SELECT  @script = definition
    FROM    sys.sql_modules
    WHERE   [object_id] = OBJECT_ID(@storeProcedureName);

	--find start of text
    DECLARE @metaStartIndex INT = CHARINDEX('#MetaStart', @script);
    IF ( @metaStartIndex = 0 )
        RETURN NULL;
    SET @metaStartIndex = @metaStartIndex + LEN('#MetaStart');

    DECLARE @metaEndIndex INT = CHARINDEX('#MetaEnd', @script, @metaStartIndex);
    IF ( @metaEndIndex = 0 )
        RETURN NULL;

    RETURN SUBSTRING(@script, @metaStartIndex, @metaEndIndex-@metaStartIndex);
END;
 










