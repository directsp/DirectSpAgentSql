CREATE PROC [dsp].[Synonym_Create]
	@schemaName TSTRING, @synonymName TSTRING, @objectName TSTRING
AS
BEGIN
	DECLARE @sql TSTRING;

	-- drop if already exists
	SET @sql = 'DROP SYNONYM IF EXISTS ' + @schemaName + '.' + @synonymName;
	EXEC sys.sp_executesql @stmt = @sql;

	-- create synonym
	SET @sql = 'CREATE SYNONYM ' + @schemaName + '.' + @synonymName + ' FOR ' + @objectName;
	EXEC sys.sp_executesql @stmt = @sql;
END;