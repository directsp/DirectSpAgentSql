CREATE PROCEDURE [tCodeQuality].[test dataAccessMode annotation existance in proc]
AS
BEGIN
    DECLARE @msg TBIGSTRING = --
            (   SELECT  CHAR(10) + VPD.schemaName + '.' + VPD.objectName
                  FROM  dsp.Metadata_ProceduresDefination() AS VPD
                 WHERE  VPD.Type = 'P' AND  VPD.schemaName = 'api' AND --
                        JSON_VALUE(dsp.Metadata_StoreProcedureAnnotation(VPD.schemaName + '.' + VPD.objectName), '$.dataAccessMode') IS NULL
                FOR XML PATH(''));

	IF (@msg IS NOT NULL) --		
        EXEC dsp.Exception_ThrowGeneral @message = @msg;


    SET @msg = --
            (   SELECT  CHAR(10) + VPD.schemaName + '.' + VPD.objectName
                  FROM  dsp.Metadata_ProceduresDefination() AS VPD
                 WHERE  VPD.Type = 'P' AND  VPD.schemaName = 'api' --
                    AND JSON_VALUE(dsp.Metadata_StoreProcedureAnnotation(VPD.schemaName + '.' + VPD.objectName), '$.dataAccessMode') IS NOT NULL --
                    AND JSON_VALUE(dsp.Metadata_StoreProcedureAnnotation(VPD.schemaName + '.' + VPD.objectName), '$.dataAccessMode') NOT IN ( 'read', 'write', 'readSnapshot' )
                FOR XML PATH(''));


	IF (@msg IS NOT NULL)
		EXEC dsp.Exception_ThrowGeneral @message = @msg;
END;


