CREATE FUNCTION dsp.Metadata_objectExists (@schemaName TSTRING,
    @objectName TSTRING,
    @typeName TSTRING)
RETURNS BIT
BEGIN

    DECLARE @isExist BIT = 0;
    SELECT  @isExist = 1
      FROM  sys.objects AS O
            INNER JOIN sys.schemas
AS      S ON O.schema_id = S.schema_id
     WHERE  S.name = @schemaName --
        AND O.name = @objectName --
        AND O.type = @typeName;
    RETURN @isExist;

END;