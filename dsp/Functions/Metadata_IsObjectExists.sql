CREATE	FUNCTION [dsp].[Metadata_IsObjectExists] (@schemaName TSTRING,
	@objectName TSTRING,
	@TypeName TSTRING)
RETURNS BIT
BEGIN

	DECLARE @isExist BIT = 0;
	SELECT	@isExist = 1
	FROM	sys.objects AS O
			INNER JOIN sys.schemas
AS		S ON O.schema_id = S.schema_id
	WHERE	S.name = @schemaName --
		AND O.name = @objectName --
		AND O.type = @TypeName;
	RETURN @isExist;

END;