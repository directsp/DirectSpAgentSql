CREATE	FUNCTION [dsp].[Metadata_IsObjectExists] (@schemaName TSTRING,
	@ObjectName TSTRING,
	@TypeName TSTRING)
RETURNS BIT
BEGIN

	DECLARE @IsExist BIT = 0;
	SELECT	@IsExist = 1
	FROM	sys.objects AS O
			INNER JOIN sys.schemas
AS		S ON O.schema_id = S.schema_id
	WHERE	S.name = @schemaName --
		AND O.name = @ObjectName --
		AND O.type = @TypeName;
	RETURN @IsExist;

END;