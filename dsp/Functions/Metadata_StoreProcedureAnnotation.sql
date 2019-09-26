
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
    DECLARE @MetaStartIndex INT = CHARINDEX('#MetaStart', @script);
    IF ( @MetaStartIndex = 0 )
        RETURN NULL;
    SET @MetaStartIndex = @MetaStartIndex + LEN('#MetaStart');

    DECLARE @MetaEndIndex INT = CHARINDEX('#MetaEnd', @script, @MetaStartIndex);
    IF ( @MetaEndIndex = 0 )
        RETURN NULL;

    RETURN SUBSTRING(@script, @MetaStartIndex, @MetaEndIndex-@MetaStartIndex);
END;
 










