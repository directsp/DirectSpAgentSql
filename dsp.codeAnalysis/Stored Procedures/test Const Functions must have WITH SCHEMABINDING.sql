CREATE PROCEDURE dspCodeAnalysis.[test Const Functions must have WITH SCHEMABINDING]
AS
BEGIN

    -- Declaring pattern
    DECLARE @pattern_context TCONTEXT = dspCodeAnalysis.Test_@removeWhitespaces('WITH SCHEMABINDING');

    DECLARE @msg TSTRING;
    DECLARE @functionName TSTRING;

    -- Looking for "@context TCONTEXT OUT" phrase
    SELECT  @functionName = SV.fullName
      FROM  dspCodeAnalysis.ScriptView AS SV
     WHERE  (SV.schemaName = 'const' OR CHARINDEX('Const_', SV.scriptName) = 1) --
        AND CHARINDEX(@pattern_context, SV.scriptNoSpace) < 1 AND  CHARINDEX('return.tstring', SV.scriptNoSpace) = 0;

    IF (@functionName IS NOT NULL)
    BEGIN
        SET @msg = '"WITH SCHEMABINDING" phrase was not found in Function: ' + @functionName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;
END;