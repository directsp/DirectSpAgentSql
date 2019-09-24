
-- Create Procedure RecreateStringFunctions
CREATE PROC [dsp].[Init_$RecreateStringFunctions]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @FunctionBody TSTRING =
		'
CREATE FUNCTION @schemaName.@KeyColumnValue() 
RETURNS TSTRING
AS 
BEGIN
	RETURN dsp.StringTable_Value(''@KeyColumnValue'');
END';

	EXEC dsp.Init_RecreateEnumFunctions @schemaName = 'str', @tableSchemaName = 'dsp', @tableName = 'StringTable', @keyColumnName = 'StringId', @textColumnName = 'StringValue', @functionBody = @FunctionBody;
END;