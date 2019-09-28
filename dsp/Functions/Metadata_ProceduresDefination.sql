CREATE FUNCTION [dsp].[Metadata_proceduresDefination] ()
RETURNS TABLE
AS
RETURN SELECT	S.name AS schemaName, O.name AS objectName, O.type AS Type, OBJECT_DEFINITION(O.object_id) AS script
		FROM	sys.objects AS O
				INNER JOIN sys.schemas AS S ON S.schema_id = O.schema_id
		WHERE	O.type IN ( 'FN', 'IF', 'TF', 'P' );