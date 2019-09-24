﻿CREATE PROC [tCodeQuality].[test Declare BIGINT]
AS
BEGIN
    -- Getting procedures which have bigint columns with int declaration
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting procedures which have bigint columns with int declaration';
    DECLARE @ProcInfo TABLE (SchemaName TSTRING,
        ProcedureName TSTRING,
        DEFINITION TBIGSTRING,
        ColumnName TSTRING);
    INSERT  @ProcInfo (SchemaName, ProcedureName, DEFINITION, ColumnName)
    EXEC tCodeQuality.Private_ColumnsWithBigintTypes;

    -- Checking if there is any wrong type for Bigint Columns
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Checking if there is any wrong type for Bigint Columns';
    DECLARE @procName TSTRING = '';
    DECLARE @ParamName TSTRING = '';
    IF EXISTS (SELECT   1 FROM  @ProcInfo AS PI)
    BEGIN
        DECLARE @message TSTRING =
                (   SELECT     CHAR(10) +  N'in the procedure "' + PI.SchemaName + '.' + PI.ProcedureName + '", parameter "',
                        PI.ColumnName + '" has wrong parameter data type!'
                      FROM      @ProcInfo AS PI
                    FOR XML PATH(''));

        EXEC tSQLt.Fail @Message0 = @message;
    END;
END;







