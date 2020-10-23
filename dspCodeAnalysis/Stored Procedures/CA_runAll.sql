
-- A simple checkup
-- Note: You do not need to use this method if you install tSQLt in your project
CREATE PROC dspCodeAnalysis.CA_runAll
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @schema TSTRING = OBJECT_SCHEMA_NAME(@@PROCID);

    --Drop String Functions
    DECLARE _cursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
    SELECT  O.name
      FROM  sys.objects AS O
            INNER JOIN sys.schemas AS S ON S.schema_id = O.schema_id
     WHERE  S.name = @schema AND O.type = N'P' ORDER BY O.name

    DECLARE @procName TSTRING;

    -- find tests
    OPEN _cursor;
    WHILE (1 = 1)
    BEGIN
        FETCH NEXT FROM _cursor
         INTO @procName;
        IF (@@FETCH_STATUS <> 0)
            BREAK;

        -- ignore non test procedures
        IF (CHARINDEX('test ', @procName) <> 1)
            CONTINUE;

        DECLARE @fullProcName TSTRING = '[' + @schema + '].[' + @procName + ']';
        DECLARE @result TSTRING = @fullProcName + '=> ';

        -- run the test
        BEGIN TRY
            BEGIN TRANSACTION;
            DECLARE @sql TSTRING = 'EXEC ' + @fullProcName;
            EXEC sys.sp_executesql @stmt = @sql;
            SET @result = @result + 'OK';
			PRINT @result;
            ROLLBACK TRANSACTION;

        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            PRINT ERROR_MESSAGE();
            SET @result = @result + 'Failed';
			PRINT @result;
			DECLARE @msg TSTRING = ERROR_MESSAGE();
			RAISERROR(@msg, 11, 0) WITH NOWAIT;
        END CATCH;

    END;
    CLOSE _cursor;
    DEALLOCATE _cursor;

	

END;