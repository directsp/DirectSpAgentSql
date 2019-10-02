CREATE PROC tCodeQuality.[test ValidateSubstitutionOfFunctioncallWithInteger]
AS
BEGIN
    SET NOCOUNT ON;
    -- Getting Stored Procedures and Functions definition
    DECLARE _cursor CURSOR FAST_FORWARD FORWARD_ONLY FORWARD_ONLY LOCAL FOR
    SELECT  SV.schemaName, SV.schemaName, SV.script
      FROM  tCodeQuality.ScriptView AS SV

    OPEN _cursor;

    DECLARE @script TBIGSTRING;
    DECLARE @objectName TSTRING;
    DECLARE @schemaName TSTRING;
    DECLARE @pattern TSTRING = '/*co' + 'nst.';

    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _cursor
         INTO @schemaName, @objectName, @script;
        IF (@@fETCH_STATUS <> 0)
            BREAK;

        -- Removing Space, Tab, line feed
        SET @script = tCodeQuality.Test_@removeWhitespacesBig(@script);

        -- Cutting out text before /*co+nst
        DECLARE @startIndex INT = CHARINDEX(@pattern, @script);
        SET @script = SUBSTRING(@script, @startIndex - 1, (LEN(@script) - @startIndex) + 1);

        -- Validate Function Id with Corresponding value
        WHILE (CHARINDEX(@pattern, @script) > 0)
        BEGIN
            DECLARE @constFunctionName TSTRING;
            DECLARE @constValueInFunction INT;
            DECLARE @constValueInScript INT;
            DECLARE @isMatch BIT;
            EXEC tCodeQuality.Test_@compareConstFunctionReturnValueWithScriptValue @script = @script OUTPUT, @constFunctionName = @constFunctionName OUTPUT,
                @constValueInFunction = @constValueInFunction OUTPUT, @constValueInScript = @constValueInScript OUTPUT, @isMatch = @isMatch OUTPUT;

            IF (@isMatch = 0)
            BEGIN
                DECLARE @message TSTRING;
                DECLARE @fullObjectName TSTRING = @schemaName + '.' + @objectName;
                EXEC @message = dsp.Formatter_formatMessage @message = N'ConstValueInFunction({0}) and ConstValueInScript({1}) are inconsistence; the function name is: {2} in the SP: {3}',
                    @param0 = @constValueInFunction, @param1 = @constValueInScript, @param2 = @constFunctionName, @param3 = @fullObjectName;
                EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @message;
            END;

            SET @startIndex = CHARINDEX(@pattern, @script);
            SET @script = SUBSTRING(@script, @startIndex, (LEN(@script) - @startIndex) + 1);
        END;
    END;

    CLOSE _cursor;
    DEALLOCATE _cursor;
END;