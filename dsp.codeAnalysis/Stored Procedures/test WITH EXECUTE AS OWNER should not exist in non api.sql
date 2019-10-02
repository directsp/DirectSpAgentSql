
--/dsp_suppress:1012
CREATE PROCEDURE dspCodeAnalysis.[test WITH EXECUTE AS OWNER should not exist in non api]
AS
BEGIN
    -- Declaring pattern
    DECLARE @pattern_withExecuteASOwner TSTRING = dspCodeAnalysis.Test_@removeWhitespaces('WITH EXECUTE AS OWNER');
    DECLARE @pattern_withExecAsOwner TSTRING = dspCodeAnalysis.Test_@removeWhitespaces('WITH EXEC AS OWNER');
    DECLARE @msg TSTRING;
    DECLARE @procedureName TSTRING;

    -- Looking for "With Execute AS owner" phrase
    SELECT  @procedureName = SV.fullName
      FROM  dspCodeAnalysis.ScriptView AS SV
     WHERE  SV.schemaName <> 'api' AND CHARINDEX('/dsp_suppress:1012', SV.script)=0 --
        AND (CHARINDEX(@pattern_withExecuteASOwner, SV.scriptNoSpace) > 0 OR CHARINDEX(@pattern_withExecAsOwner, SV.scriptNoSpace) > 0);

    IF (@procedureName IS NOT NULL)
    BEGIN
        SET @msg = '"With Execute AS owner" phrase was found in procedure: ' + @procedureName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;
END;