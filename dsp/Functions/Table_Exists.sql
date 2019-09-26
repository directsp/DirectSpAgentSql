CREATE FUNCTION [dsp].[Table_Exists](@schemaName TSTRING, @Table TSTRING)
RETURNS INT
AS
BEGIN
    DECLARE @ret INT = 0;
	SELECT @ret = 1  FROM sys.tables AS T 
		INNER JOIN sys.schemas AS S ON S.schema_id = T.schema_id 
		WHERE T.name = @Table AND  S.name = @schemaName;
	RETURN @ret
END