CREATE FUNCTION [dsp].[Database_IsReadOnly] (@databaseName TSTRING)
RETURNS BIT
AS
BEGIN
    RETURN IIF(DATABASEPROPERTYEX(ISNULL(@databaseName, DB_NAME()), 'Updateability') = 'READ_ONLY', 1, 0);
END;


