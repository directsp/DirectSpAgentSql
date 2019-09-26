CREATE FUNCTION [dsp].[Metadata_ExtendedPropertyValueOfSchema] (@schemaName TSTRING,
	@extendedPropertyName TSTRING)
RETURNS SQL_VARIANT
AS
BEGIN
	DECLARE @value SQL_VARIANT;

	SELECT	@value = value
	FROM	sys.fn_listextendedproperty(NULL, 'SCHEMA', NULL, NULL, NULL, NULL, NULL)
	WHERE	objname = @schemaName AND	name = @extendedPropertyName;

	RETURN @value;
END;