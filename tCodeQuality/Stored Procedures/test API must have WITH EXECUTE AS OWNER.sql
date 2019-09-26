CREATE PROCEDURE [tCodeQuality].[test API must have WITH EXECUTE AS OWNER]
AS
BEGIN
    -- Declaring pattern
    DECLARE @pattern_WithExecuteASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXECUTE AS OWNER');
    DECLARE @pattern_WithExecASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXEC AS OWNER');
    DECLARE @msg TSTRING;

    -- Getting list all procedures with pagination
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting list all procedures with pagination';
    DECLARE @t TABLE (schemaName TSTRING NULL,
        procedureName TSTRING  NULL,
        script TBIGSTRING NULL);

    INSERT INTO @t
    SELECT  PD.schemaName, PD.objectName AS procedureName, dsp.String_RemoveWhitespacesBig(PD.script)
      FROM  dsp.Metadata_ProceduresDefination() AS PD
     WHERE  PD.schemaName = 'api';

    -- Looking for "With Execute AS owner" phrase
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Looking for "With Execute AS owner" phrase';
    SET @msg = (   SELECT   schemaName + '.' + procedureName AS procedureName
                     FROM   @t
                    WHERE   CHARINDEX(@pattern_WithExecuteASOwner, script) = 0 AND  CHARINDEX(@pattern_WithExecASOwner, script) = 0
                   FOR JSON AUTO);

    IF (@msg IS NOT NULL) --
        EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
END;











