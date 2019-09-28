CREATE PROCEDURE [tCodeQuality].[test API must have DataAccessMode annotation]
AS
BEGIN
    DECLARE @msg TBIGSTRING = --
            (   SELECT  CHAR(10) + VPD.schemaName + '.' + VPD.objectName
                  FROM  dsp.Metadata_proceduresDefination() AS VPD
                 WHERE  VPD.Type = 'P' AND  VPD.schemaName = 'api' AND --
                        JSON_VALUE(dsp.Metadata_storeProcedureAnnotation(VPD.schemaName + '.' + VPD.objectName), '$.dataAccessMode') IS NULL
                FOR XML PATH(''));

	IF (@msg IS NOT NULL) --		
        EXEC dsp.Exception_throwGeneral @message = @msg;


    SET @msg = --
            (   SELECT  CHAR(10) + VPD.schemaName + '.' + VPD.objectName
                  FROM  dsp.Metadata_proceduresDefination() AS VPD
                 WHERE  VPD.Type = 'P' AND  VPD.schemaName = 'api' --
                    AND JSON_VALUE(dsp.Metadata_storeProcedureAnnotation(VPD.schemaName + '.' + VPD.objectName), '$.dataAccessMode') IS NOT NULL --
                    AND JSON_VALUE(dsp.Metadata_storeProcedureAnnotation(VPD.schemaName + '.' + VPD.objectName), '$.dataAccessMode') NOT IN ( 'read', 'write', 'readSnapshot' )
                FOR XML PATH(''));


	IF (@msg IS NOT NULL)
		EXEC dsp.Exception_throwGeneral @message = @msg;
END;