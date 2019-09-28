CREATE PROCEDURE tCodeQuality.[test Relations for ForeignKeys]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @tableName TSTRING;
    DECLARE @columnName TSTRING;
    DECLARE @tableId INT;
    DECLARE @columnId INT;

    -- select all non primary column
    DECLARE _columnCusrsor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
    SELECT DISTINCT T.name AS tableName, C.name AS columnName, T.object_id AS tableId, C.column_id AS columnId
      FROM  sys.tables T
            LEFT JOIN sys.columns C ON T.object_id = C.object_id
            LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU ON SCHEMA_NAME(T.schema_id) = KU.TABLE_SCHEMA AND   T.name = KU.TABLE_NAME AND
                                                                   C.name = KU.COLUMN_NAME
            LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME AND TC.TABLE_SCHEMA = KU.TABLE_SCHEMA AND
                                                                    TC.TABLE_NAME = KU.TABLE_NAME
            LEFT JOIN sys.extended_properties P2 ON T.object_id = P2.major_id AND   C.column_id = P2.minor_id AND   P2.name = 'MS_Description'
     WHERE  C.name LIKE N'%Id' AND  (TC.CONSTRAINT_TYPE IS NULL OR  TC.CONSTRAINT_TYPE <> 'PRIMARY KEY');

    OPEN _columnCusrsor;

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _columnCusrsor
         INTO @tableName, @columnName, @tableId, @columnId;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- ignore microsoft_database_tools_support
        IF EXISTS (   SELECT    1
                        FROM    sys.extended_properties AS ep
                       WHERE ep.name = 'microsoft_database_tools_support' AND   ep.major_id = @tableId AND  ep.minor_id = @columnId)
            CONTINUE;

        -- ignore fields with /nofk
        IF EXISTS (   SELECT    1
                        FROM    sys.extended_properties AS ep
                       WHERE ep.name = 'MS_Description' AND ep.major_id = @tableId AND  ep.minor_id = @columnId AND
                             CHARINDEX(LOWER(ISNULL(dsp.Convert_toString(ep.value), '')), '/nofk') <> 0)
            CONTINUE;

		-- check for foreign key existance
        IF NOT EXISTS (   SELECT    1
                            FROM    sys.foreign_keys AS F
                                    INNER JOIN sys.foreign_key_columns AS fc ON F.object_id = fc.constraint_object_id
                           WHERE (F.parent_object_id = @tableId OR  F.referenced_object_id = @tableId) --
                              AND
                              (COL_NAME(fc.parent_object_id, fc.parent_column_id) = @columnName OR
                               COL_NAME(fc.referenced_object_id, fc.referenced_column_id) = @columnName))
        BEGIN
            DECLARE @msg TSTRING = 'Relation does not exist for ' + @tableName + '.' + @columnName;
            EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
        END;

		-- validate foreign key name
        DECLARE @flName TSTRING = 'FK_' + @tableName + '_' + @columnName;
        IF EXISTS (   SELECT    1
                        FROM    sys.foreign_keys AS F
                                INNER JOIN sys.foreign_key_columns AS fc ON F.object_id = fc.constraint_object_id
                       WHERE (F.parent_object_id = @tableId OR  F.referenced_object_id = @tableId) --
                          AND
                          (COL_NAME(fc.parent_object_id, fc.parent_column_id) = @columnName OR
                           COL_NAME(fc.referenced_object_id, fc.referenced_column_id) = @columnName) AND  F.name <> @flName)
        BEGIN
            SET @msg = 'Relation name is not correct for ' + @tableName + '.' + @columnName;
            EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
        END;

    END;
    CLOSE _columnCusrsor;
    DEALLOCATE _columnCusrsor;
END;