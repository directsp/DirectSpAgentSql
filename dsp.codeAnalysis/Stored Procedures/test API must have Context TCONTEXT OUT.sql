CREATE PROC dspCodeAnalysis.[test API must have Context TCONTEXT OUT]
AS
BEGIN

    -- Declearing pattern
    DECLARE @pattern_context TCONTEXT = dspCodeAnalysis.Test_@removeWhitespaces('@context TCONTEXT OUT');

    DECLARE @msg TSTRING;
    DECLARE @procedureName TSTRING;

    -- Looking for "@context TCONTEXT OUT" phrase
    SELECT  @procedureName = SV.fullName
      FROM  dspCodeAnalysis.ScriptView AS SV
     WHERE  CHARINDEX(@pattern_context, SV.scriptNoSpace) < 1 AND   SV.schemaName = 'api' AND   SV.type = 'P';

    IF (@procedureName IS NOT NULL)
    BEGIN
        SET @msg = '"@context TCONTEXT OUT" phrase was not found in procedure: ' + @procedureName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;
END;