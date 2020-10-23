

CREATE VIEW [dspCodeAnalysis].[ScriptView]
AS
SELECT  S.name + '.' + O.name AS fullName, S.name AS schemaName, O.name AS scriptName, O.type AS type, OBJECT_DEFINITION(O.object_id) AS script,
    LOWER(dspCodeAnalysis.CA_@removeWhitespacesBig(OBJECT_DEFINITION(O.object_id))) AS scriptNoSpace
  FROM  sys.objects AS O
        INNER JOIN sys.schemas AS S ON S.schema_id = O.schema_id
 WHERE  O.type IN ( 'FN', 'IF', 'TF', 'P' ) AND dspCodeAnalysis.CA_@IsTargetSchema(S.name) = 1;