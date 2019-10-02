
--/dsp_suppress:1012
CREATE PROCEDURE [tCodeQuality].[test API must have WITH EXECUTE AS OWNER]
AS
BEGIN
    -- Declaring pattern
    DECLARE @pattern_withExecuteASOwner TSTRING = tCodeQuality.Test_@removeWhitespaces('WITH EXECUTE AS OWNER');
    DECLARE @pattern_withExecASOwner TSTRING = tCodeQuality.Test_@removeWhitespaces('WITH EXEC AS OWNER');
    DECLARE @msg TSTRING;

    -- Looking for "With Execute AS owner" phrase
    SET @msg =
    (   SELECT      SV.fullName AS procedureName
          FROM      tCodeQuality.ScriptView AS SV
         WHERE   SV.schemaName = 'api' AND   SV.type = 'P' AND   CHARINDEX(@pattern_withExecuteASOwner, SV.scriptNoSpace) = 0 AND
                 CHARINDEX(@pattern_withExecASOwner, SV.scriptNoSpace) = 0
        FOR JSON AUTO);

    IF (@msg IS NOT NULL) --
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
END;