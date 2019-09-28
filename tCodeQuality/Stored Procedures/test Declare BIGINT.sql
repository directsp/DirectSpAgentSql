CREATE PROC tCodeQuality.[test Declare BIGINT]
AS
BEGIN
    -- Getting procedures which have bigint columns with int declaration
    DECLARE @procInfo TABLE (schemaName TSTRING NULL,
        procedureName TSTRING NULL,
        DEFINITION TBIGSTRING NULL,
        columnName TSTRING NULL);
    INSERT  @procInfo (schemaName, procedureName, DEFINITION, columnName)
    EXEC tCodeQuality.Test_@columnsWithBigintTypes;

    -- Checking if there is any wrong type for Bigint Columns
    IF EXISTS (SELECT   1 FROM  @procInfo AS PI)
    BEGIN
        DECLARE @message TSTRING =
                (   SELECT     CHAR(10) +  N'in the procedure "' + PI.schemaName + '.' + PI.procedureName + '", parameter "',
                        PI.columnName + '" has wrong parameter data type!'
                      FROM      @procInfo AS PI
                    FOR XML PATH(''));

        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @message;
    END;
END;







