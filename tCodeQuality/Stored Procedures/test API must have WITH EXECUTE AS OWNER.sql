CREATE PROCEDURE [tCodeQuality].[test API must have WITH EXECUTE AS OWNER]
AS
BEGIN
    -- Declaring pattern
    DECLARE @pattern_withExecuteASOwner TSTRING = dsp.String_removeWhitespaces('WITH EXECUTE AS OWNER');
    DECLARE @pattern_withExecASOwner TSTRING = dsp.String_removeWhitespaces('WITH EXEC AS OWNER');
    DECLARE @msg TSTRING;

    -- Getting list all procedures with pagination
    DECLARE @t TABLE (schemaName TSTRING NULL,
        procedureName TSTRING  NULL,
        script TBIGSTRING NULL);

    INSERT INTO @t
    SELECT  PD.schemaName, PD.objectName AS procedureName, dsp.String_removeWhitespacesBig(PD.script)
      FROM  dsp.Metadata_proceduresDefination() AS PD
     WHERE  PD.schemaName = 'api';

    -- Looking for "With Execute AS owner" phrase
    SET @msg = (   SELECT   schemaName + '.' + procedureName AS procedureName
                     FROM   @t
                    WHERE   CHARINDEX(@pattern_withExecuteASOwner, script) = 0 AND  CHARINDEX(@pattern_withExecASOwner, script) = 0
                   FOR JSON AUTO);

    IF (@msg IS NOT NULL) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
END;











