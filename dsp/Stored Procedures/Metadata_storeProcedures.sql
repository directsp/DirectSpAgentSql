CREATE PROCEDURE [dsp].[Metadata_storeProcedures]
    @api TJSON OUT
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @params TABLE (paramName TSTRING NULL,
        isOutput BIT NULL,
        systemTypeName TSTRING NULL,
        userTypeName TSTRING NULL,
        length INT NULL,
        object_id INT NULL);

    INSERT INTO @params (paramName, isOutput, systemTypeName, userTypeName, length, object_id)
    SELECT  params.name AS paramName, params.is_output, TYPE_NAME(Type.system_type_id) AS systemTypeName, TYPE_NAME(Type.user_type_id) AS userTypeName,
        params.max_length AS length, params.object_id
      FROM  sys.parameters AS params
            INNER JOIN sys.types AS Type ON Type.user_type_id = params.user_type_id;

    SET @api =
        CAST((   SELECT [Procedure].schemaName, [Procedure].name AS procedureName, params.paramName, params.isOutput, params.systemTypeName,
                     params.userTypeName, params.length AS length, [Procedure].extendedProps AS extendedProps
                   FROM (   SELECT  [Procedure].object_id, [Schema].name AS schemaName, [Procedure].name,
                                JSON_QUERY(dsp.Metadata_storeProcedureAnnotation([Schema].name + '.' + [Procedure].name), '$') AS extendedProps
                              FROM  sys.procedures AS [Procedure]
                                    INNER JOIN sys.schemas AS [Schema] ON [Schema].schema_id = [Procedure].schema_id) AS [Procedure]
                        INNER JOIN @params AS params ON params.object_id = [Procedure].object_id
                  WHERE --dsp.Metadata_extendedPropertyValueOfSchema([Procedure].schemaName, @extendedPropertyName) = 1 OR	
                     [Procedure].schemaName = 'api'
                  ORDER BY [Procedure].name
                 FOR JSON AUTO) AS NVARCHAR(/*NoCodeQuality*/ MAX));
END;