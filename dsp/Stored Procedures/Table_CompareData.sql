CREATE PROC [dsp].[Table_compareData]
	@sourceSchemaName TSTRING = NULL, @sourceTableName TSTRING = NULL, @destinationTableName TSTRING, @destinationSchemaName TSTRING = 'dbo',
	@isWithDelete BIT = 1
AS
BEGIN
	SET @sourceTableName = ISNULL(@sourceSchemaName, '#' + @destinationTableName);

	DECLARE @sourceTable TSTRING = @sourceTableName;
	IF (dsp.Formatter_formatString(@sourceSchemaName) IS NOT NULL)
		SET @sourceTable = @sourceSchemaName + '.' + @sourceTableName;

	DECLARE @destinationTable TSTRING = @destinationTableName;
	IF (dsp.Formatter_formatString(@destinationSchemaName) IS NOT NULL)
		SET @destinationTable = @destinationSchemaName + '.' + @destinationTableName;

	-- find primary key
	DECLARE @primaryKey TSTRING;
	SELECT	@primaryKey = COLUMN_NAME
	FROM	INFORMATION_SCHEMA.KEY_COLUMN_USAGE
	WHERE	OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1 AND TABLE_NAME = @destinationTableName AND
			TABLE_SCHEMA = @destinationSchemaName;

	IF (@primaryKey IS NULL)
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'Could not find Primary key for table {0}!', @param0 = @destinationTableName

	-- columns
	DECLARE @columnsForUpdate TSTRING =
			(	SELECT		',' + c.name + '=S.' + c.name
				FROM	sys.columns c
						INNER JOIN sys.objects o ON o.object_id = c.object_id
						LEFT JOIN sys.types t ON t.user_type_id = c.user_type_id
				WHERE	o.type = 'U' AND SCHEMA_NAME(o.schema_id) = @destinationSchemaName AND	o.name = @destinationTableName AND	c.is_identity = 0 AND
						c.name <> @primaryKey
				FOR XML PATH(''));

	SET @columnsForUpdate = STUFF(@columnsForUpdate, 1, 1, '');

		-- columns
	DECLARE @columnsForInsert TSTRING =
			(	SELECT		',' + c.name 
				FROM	sys.columns c
						INNER JOIN sys.objects o ON o.object_id = c.object_id
						LEFT JOIN sys.types t ON t.user_type_id = c.user_type_id
				WHERE	o.type = 'U' AND SCHEMA_NAME(o.schema_id) = @destinationSchemaName AND	o.name = @destinationTableName 	
				FOR XML PATH(''));

	SET @columnsForInsert = STUFF(@columnsForInsert, 1, 1, '');

	DECLARE @sql TSTRING =
		'
		UPDATE @destinationTable SET @columnsForUpdate FROM @sourceTable AS S WHERE S.@primaryKey=@destinationTable.@primaryKey;

		INSERT @destinationTable (@columnsForInsert) SELECT * FROM @sourceTable AS S WHERE S.@primaryKey NOT IN (SELECT @primaryKey FROM @destinationTable AS S);

		IF (@isWithDelete=1)
			DELETE @destinationTable WHERE @primaryKey NOT IN (SELECT @primaryKey FROM @sourceTable AS S);
	';
	SET @sql = REPLACE(@sql, '@isWithDelete', @isWithDelete);
	SET @sql = REPLACE(@sql, '@sourceTable', @sourceTable);
	SET @sql = REPLACE(@sql, '@destinationTable', @destinationTable);
	SET @sql = REPLACE(@sql, '@primaryKey', @primaryKey);
	SET @sql = REPLACE(@sql, '@columnsForUpdate', @columnsForUpdate);
	SET @sql = REPLACE(@sql, '@columnsForInsert', @columnsForInsert);

	EXEC sys.sp_executesql @stmt = @sql;
END;