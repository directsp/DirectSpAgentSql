


CREATE VIEW [dspCodeAnalysis].[TableView]
AS
SELECT DISTINCT S.name AS schemaName, T.name AS tableName, T.schema_id AS schemaId, T.object_id AS tableId, S.name + '.' + T.name AS fullName, T.*
  FROM  sys.tables AS T
        INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id
 WHERE  dspCodeAnalysis.CA_@IsTargetSchema(S.name) = 1 AND  T.name <> '__RefactorLog';