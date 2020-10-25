CREATE PROCEDURE [dspCodeAnalysis].[test API must have DataAccessMode annotation]
AS
BEGIN
    DECLARE @msg TBIGSTRING = --
            (   SELECT  CHAR(10) + VPD.fullName
                  FROM  dspCodeAnalysis.ScriptView AS VPD 
                 WHERE  VPD.type = 'P' AND  VPD.schemaName = 'api' AND --
                        JSON_VALUE(dsp.Metadata_storeProcedureAnnotation(VPD.fullName), '$.dataAccessMode') IS NULL
                FOR XML PATH(''));

	IF (@msg IS NOT NULL) --		
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;


    SET @msg = --
            (   SELECT  CHAR(10) + VPD.fullName
                  FROM  dspCodeAnalysis.ScriptView AS VPD 
                 WHERE  VPD.type = 'P' AND  VPD.schemaName = 'api' --
                    AND JSON_VALUE(dsp.Metadata_storeProcedureAnnotation(VPD.fullName), '$.dataAccessMode') IS NOT NULL --
                    AND JSON_VALUE(dsp.Metadata_storeProcedureAnnotation(VPD.fullName), '$.dataAccessMode') NOT IN ( 'read', 'write', 'readSnapshot' )
                FOR XML PATH(''));


	IF (@msg IS NOT NULL)
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
END;