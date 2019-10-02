
-- /dsp_suppress:1010
CREATE PROCEDURE tCodeQuality.[test Declare generic types INT, TSTRING]
AS
BEGIN
    DECLARE @msg TSTRING;
    DECLARE @procedureName TSTRING;

    -- Looking for "tinyint and smallint" phrase
    SET @procedureName = NULL;
    SELECT  @procedureName = SV.fullName
      FROM  tCodeQuality.ScriptView AS SV
     WHERE  CHARINDEX('/dsp_suppress:1010.', SV.scriptNoSpace) = 0 AND
                                                                  (CHARINDEX('tinyint', SV.scriptNoSpace) > 0 OR  CHARINDEX('smallint', SV.scriptNoSpace) > 0);
    IF (@procedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Code should not contains SMALLINT or TINYINT in procedure: ' + @procedureName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;

    -- Looking for "NVARCHAR(MAX)" phrase
    SET @procedureName = NULL;
    SELECT  @procedureName = SV.fullName
      FROM  tCodeQuality.ScriptView AS SV
     WHERE  CHARINDEX('/dsp_suppress:1010.', SV.scriptNoSpace) = 0 AND   (SV.script LIKE '%VARCHAR([0-9]%' OR SV.script LIKE '%VARCHAR(MAX)%');

    IF (@procedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Code should not contains NVARCHAR(XX) in procedure: ' + @procedureName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;

END;