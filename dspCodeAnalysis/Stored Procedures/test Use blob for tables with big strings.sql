
CREATE PROCEDURE [dspCodeAnalysis].[test Use blob for tables with big strings]
AS
BEGIN
    DECLARE @result TSTRING = NULL;

    SELECT DISTINCT @result = STRING_AGG(TB.fullName, ',')
      FROM  dspCodeAnalysis.TableView AS TB
            INNER JOIN sys.columns c ON c.object_id = TB.tableId
            INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
            INNER JOIN sys.schemas AS S ON S.schema_id = t.schema_id
     WHERE  c.max_length = -1 AND   (t.name = 'nvarchar' OR t.name = 'varchar') AND TB.large_value_types_out_of_row = 0;

    IF (@result IS NOT NULL)
    BEGIN
        PRINT REPLACE(@result, ',', CHAR(13));
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = 'There are some tables with large text field but not set as blob. Tables: {0}',
            @param0 = @result;
    END;
END;