CREATE FUNCTION [dsp].[Table_Exists](@schemaName TSTRING, @Table TSTRING)
RETURNS INT
AS
BEGIN
    DECLARE @Ret INT = 0;
	SELECT @Ret = 1  FROM sys.tables AS T 
		INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id 
		WHERE T.name = @Table AND  S.name = @schemaName;
	RETURN @Ret
END