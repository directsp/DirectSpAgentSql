CREATE PROC [tCodeQuality].[test Declare BIGINT]
AS
BEGIN
    -- Getting procedures which have bigint columns with int declaration
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting procedures which have bigint columns with int declaration';
    DECLARE @procInfo TABLE (schemaName TSTRING NULL,
        procedureName TSTRING NULL,
        DEFINITION TBIGSTRING NULL,
        columnName TSTRING NULL);
    INSERT  @procInfo (schemaName, procedureName, DEFINITION, columnName)
    EXEC tCodeQuality.Private_ColumnsWithBigintTypes;

    -- Checking if there is any wrong type for Bigint Columns
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Checking if there is any wrong type for Bigint Columns';

    IF EXISTS (SELECT   1 FROM  @procInfo AS PI)
    BEGIN
        DECLARE @message TSTRING =
                (   SELECT     CHAR(10) +  N'in the procedure "' + PI.schemaName + '.' + PI.procedureName + '", parameter "',
                        PI.columnName + '" has wrong parameter data type!'
                      FROM      @procInfo AS PI
                    FOR XML PATH(''));

        EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @message;
    END;
END;







