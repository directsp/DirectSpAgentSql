
-- Create Procedure RecreatePermissionFunctions
CREATE PROC [dsp].[Init_RecreateEnumFunctions]
	@schemaName TSTRING, @tableSchemaName TSTRING = 'dbo', @tableName TSTRING, @keyColumnName TSTRING, @textColumnName TSTRING, @functionBody TSTRING = NULL, @functionNamePostfix TSTRING = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @keyColumnValue TSTRING;
	DECLARE @textColumnValue TSTRING;
	DECLARE @sql TSTRING;
	SET @functionNamePostfix = ISNULL(@functionNamePostfix, '');

	-- Set default function body
	IF (@functionBody IS NULL)
	BEGIN
		SET @functionBody = '
CREATE FUNCTION @schemaName.@textColumnValue@functionNamePostfix()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN @KeyColumnValue;  
END
'	;
	END;
	SET @functionBody = REPLACE(@functionBody, '@schemaName', @schemaName);
	SET @functionBody = REPLACE(@functionBody, '@functionNamePostfix', @functionNamePostfix);

	-- Drop Functions
	EXEC dsp.Schema_DropObjects @schemaName = @schemaName, @dropFunctions = 1;

	CREATE TABLE #EnumIdName (ObjectId NVARCHAR(/*Ignore code quality*/ 500),
		ObjectName NVARCHAR(/*Ignore code quality*/ 500));
	SET @sql = 'INSERT INTO #EnumIdName (ObjectId, ObjectName) SELECT @KeyColumnName, @TextColumnName FROM @TableSchemaName.@TableName';
	SET @sql = REPLACE(@sql, '@TableSchemaName', @tableSchemaName);
	SET @sql = REPLACE(@sql, '@TableName', @tableName);
	SET @sql = REPLACE(@sql, '@KeyColumnName', @keyColumnName);
	SET @sql = REPLACE(@sql, '@TextColumnName', @textColumnName);
	EXEC sys.sp_executesql @stmt = @sql;

	-- Recreate Permissions Functions
	DECLARE LocalCursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT E.ObjectId, E.ObjectName FROM #EnumIdName AS E;
	OPEN LocalCursor;
	WHILE (1 = 1)
	BEGIN
		FETCH NEXT FROM LocalCursor
		INTO @keyColumnValue, @textColumnValue;
		IF (@@FETCH_STATUS <> 0)
			BREAK;

		SET @sql = @functionBody;

		SET @sql = REPLACE(@sql, '@textColumnValue', @textColumnValue);
		SET @sql = REPLACE(@sql, '@KeyColumnValue', @keyColumnValue);

		EXEC sys.sp_executesql @stmt = @sql;
	END;
	CLOSE LocalCursor;
	DEALLOCATE LocalCursor;

	DROP TABLE #EnumIdName;

END;