
-- Create Procedure RecreateStringFunctions
CREATE PROC dsp.Init_@recreateStringFunctions
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @functionBody TSTRING =
		'
CREATE FUNCTION @schemaName.@keyColumnValue() 
RETURNS TSTRING
AS 
BEGIN
	RETURN dsp.StringTable_value(''@keyColumnValue'');
END';

	EXEC dsp.Init_recreateEnumFunctions @schemaName = 'str', @tableSchemaName = 'dsp', @tableName = 'StringTable', @keyColumnName = 'stringId', @textColumnName = 'stringValue', @functionBody = @functionBody;
END;