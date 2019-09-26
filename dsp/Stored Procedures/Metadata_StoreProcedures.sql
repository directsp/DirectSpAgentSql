CREATE PROCEDURE [dsp].[Metadata_StoreProcedures]
    @api TJSON OUT
AS
BEGIN
    DECLARE @params TABLE (paramName TSTRING NULL,
        isOutput BIT NULL,
        systemTypeName TSTRING NULL,
        userTypeName TSTRING NULL,
        length INT NULL,
        object_id INT NULL);

    INSERT INTO @params (paramName, isOutput, systemTypeName, userTypeName, length, object_id)
    SELECT  Params.name AS paramName, Params.is_output, TYPE_NAME(Type.system_type_id) AS systemTypeName, TYPE_NAME(Type.user_type_id) AS userTypeName,
        Params.max_length AS length, Params.object_id
      FROM  sys.parameters AS Params
            INNER JOIN sys.types AS Type ON Type.user_type_id = Params.user_type_id;

    SET @api =
        CAST((   SELECT [Procedure].schemaName, [Procedure].name AS procedureName, Params.paramName, Params.isOutput, Params.systemTypeName,
                     Params.userTypeName, Params.length AS length, [Procedure].ExtendedProps AS ExtendedProps
                   FROM (   SELECT  [Procedure].object_id, [Schema].name AS schemaName, [Procedure].name,
                                JSON_QUERY(dsp.Metadata_StoreProcedureAnnotation([Schema].name + '.' + [Procedure].name), '$') AS ExtendedProps
                              FROM  sys.procedures AS [Procedure]
                                    INNER JOIN sys.schemas AS [Schema] ON [Schema].schema_id = [Procedure].schema_id) AS [Procedure]
                        INNER JOIN @params AS Params ON Params.object_id = [Procedure].object_id
                  WHERE --dsp.Metadata_ExtendedPropertyValueOfSchema([Procedure].schemaName, @extendedPropertyName) = 1 OR	
                     [Procedure].schemaName = 'api'
                  ORDER BY [Procedure].name
                 FOR JSON AUTO) AS NVARCHAR(/*NoCodeQuality*/ MAX));
END;












