
CREATE PROCEDURE tCodeQuality.[test API must have Context_verify]
AS
BEGIN
    DECLARE @msg TSTRING;
    DECLARE @procedureName TSTRING;

    -- Looking for "Context_verify" in api procedure
    SELECT  @procedureName = SV.fullName
      FROM  tCodeQuality.ScriptView AS SV
     WHERE  (SV.schemaName IN ( 'api' )) AND SV.type = 'P' AND  CHARINDEX('dsp.context_verify', SV.scriptNoSpace) = 0;

    IF (@procedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Code should contain dsp.Context_verify in procedure: ' + @procedureName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;
END;