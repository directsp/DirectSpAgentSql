
CREATE PROC [dsp].[Init_$RecreateExceptionFunctions]
AS
BEGIN
    SET NOCOUNT ON;
    -- Drop err Functions and procedures
    EXEC dsp.Schema_DropObjects @schemaName = 'err', @dropFunctions = 1, @dropProcedures = 1;

    -- Recreate err constant functions
    EXEC dsp.Init_RecreateEnumFunctions @schemaName = 'err', @tableSchemaName = 'dsp', @tableName = 'Exception', @keyColumnName = 'ExceptionId',
        @textColumnName = 'ExceptionName', @functionNamePostfix = 'Id';

    -- Recreate Throw procedures
    DECLARE @exceptionId  INT;
    DECLARE @ExceptionName TSTRING;

    DECLARE CreateFunctionCursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT E.ExceptionName, E.ExceptionId FROM dsp.Exception AS E;
    OPEN CreateFunctionCursor;
    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM CreateFunctionCursor
         INTO @ExceptionName, @exceptionId ;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        DECLARE @Sql TSTRING =
            '
CREATE PROC err.Throw{@ExceptionName} @procId INT, @message TSTRING = NULL, @param0 TSTRING = ''<notset>'', @param1 TSTRING = ''<notset>'', @param2 TSTRING = ''<notset>'', @param3 TSTRING = ''<notset>''
AS
BEGIN
    DECLARE @exceptionId  INT = err.{@ExceptionName}Id();
    EXEC dsp.ThrowAppException @procId = @procId, @exceptionId  = @exceptionId , @message = @message, @param0 = @param0, @param1 = @param1,
        @param2 = @param2, @param3 = @param3;
END'    ;
        SET @Sql = REPLACE(@Sql, '{@ExceptionName}', @ExceptionName);
        EXEC (@Sql);
    END;
    CLOSE CreateFunctionCursor;
    DEALLOCATE CreateFunctionCursor;

END;