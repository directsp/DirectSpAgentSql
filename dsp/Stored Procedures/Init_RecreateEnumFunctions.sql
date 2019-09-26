
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
	RETURN @keyColumnValue;  
END
'	;
	END;
	SET @functionBody = REPLACE(@functionBody, '@schemaName', @schemaName);
	SET @functionBody = REPLACE(@functionBody, '@functionNamePostfix', @functionNamePostfix);

	-- Drop Functions
	EXEC dsp.Schema_DropObjects @schemaName = @schemaName, @dropFunctions = 1;

	CREATE TABLE #EnumIdName (ObjectId NVARCHAR(/*Ignore code quality*/ 500),
		objectName NVARCHAR(/*Ignore code quality*/ 500));
	SET @sql = 'INSERT INTO #EnumIdName (ObjectId, objectName) SELECT @keyColumnName, @TextColumnName FROM @TableSchemaName.@tableName';
	SET @sql = REPLACE(@sql, '@TableSchemaName', @tableSchemaName);
	SET @sql = REPLACE(@sql, '@tableName', @tableName);
	SET @sql = REPLACE(@sql, '@keyColumnName', @keyColumnName);
	SET @sql = REPLACE(@sql, '@TextColumnName', @textColumnName);
	EXEC sys.sp_executesql @stmt = @sql;

	-- Recreate Permissions Functions
	DECLARE LocalCursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT E.ObjectId, E.objectName FROM #EnumIdName AS E;
	OPEN LocalCursor;
	WHILE (1 = 1)
	BEGIN
		FETCH NEXT FROM LocalCursor
		INTO @keyColumnValue, @textColumnValue;
		IF (@@fETCH_STATUS <> 0)
			BREAK;

		SET @sql = @functionBody;

		SET @sql = REPLACE(@sql, '@textColumnValue', @textColumnValue);
		SET @sql = REPLACE(@sql, '@keyColumnValue', @keyColumnValue);

		EXEC sys.sp_executesql @stmt = @sql;
	END;
	CLOSE LocalCursor;
	DEALLOCATE LocalCursor;

	DROP TABLE #EnumIdName;

END;