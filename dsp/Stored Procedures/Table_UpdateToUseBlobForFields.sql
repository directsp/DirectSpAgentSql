CREATE PROCEDURE dsp.Table_updateToUseBlobForFields
AS
BEGIN
	DECLARE @tableName TSTRING;

	DECLARE _cursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
	SELECT	T2.name
	FROM	sys.tables AS T2
			INNER JOIN sys.columns c ON c.object_id = T2.object_id
			INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
			LEFT OUTER JOIN sys.index_columns ic ON ic.object_id = c.object_id AND	ic.column_id = c.column_id
			LEFT OUTER JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
			INNER JOIN sys.schemas AS S ON S.schema_id = T2.schema_id
	WHERE	c.max_length = -1 AND	t.name = 'nvarchar' AND S.name = 'dbo'
	GROUP BY T2.name;
	OPEN _cursor;
	FETCH NEXT FROM _cursor
	INTO @tableName;

	WHILE (@@fETCH_STATUS = 0)
	BEGIN
		IF (@tableName IS NOT NULL) --
			EXEC sys.sp_tableoption @TableNamePattern = @tableName, @optionName = 'large value types out of row', @optionValue = 'ON';
		FETCH NEXT FROM _cursor
		INTO @tableName;
	END;
	CLOSE _cursor;
	DEALLOCATE _cursor;
END;