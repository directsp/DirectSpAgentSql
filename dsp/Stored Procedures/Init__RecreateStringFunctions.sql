
-- Create Procedure RecreateStringFunctions
CREATE PROC [dsp].[Init_$RecreateStringFunctions]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @functionBody TSTRING =
		'
CREATE FUNCTION @schemaName.@keyColumnValue() 
RETURNS TSTRING
AS 
BEGIN
	RETURN dsp.StringTable_Value(''@keyColumnValue'');
END';

	EXEC dsp.Init_RecreateEnumFunctions @schemaName = 'str', @tableSchemaName = 'dsp', @tableName = 'StringTable', @keyColumnName = 'stringId', @textColumnName = 'stringValue', @functionBody = @functionBody;
END;