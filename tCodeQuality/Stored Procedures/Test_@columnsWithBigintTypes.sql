
CREATE PROC tCodeQuality.Test_@columnsWithBigintTypes
AS
BEGIN
    WITH BigIntColumns
        AS (SELECT  Tbl.name AS tableName, C.name AS columnName
              FROM  sys.columns AS C
                    INNER JOIN sys.types AS T ON T.user_type_id = C.user_type_id
                    INNER JOIN sys.tables AS Tbl ON Tbl.object_id = C.object_id
             WHERE  T.name = 'bigint')
    SELECT  DISTINCT S.name AS schemaName, P.name AS procedureName, SM.definition, BC.columnName
      FROM  BigIntColumns AS BC, sys.procedures AS P
                                 INNER JOIN sys.schemas AS S ON S.schema_id = P.schema_id
                                 INNER JOIN sys.sql_modules AS SM ON SM.object_id = P.object_id
     WHERE  tCodeQuality.Test_@removeWhitespacesBig(REPLACE(SM.definition, 'INTO', '')) LIKE '%' + BC.columnName + 'INT%' --
        AND S.name <> 'tSQLt';
END;