CREATE PROC [dsp].[Synonym_Create]
	@schemaName TSTRING, @SynonymName TSTRING, @ObjectName TSTRING
AS
BEGIN
	DECLARE @sql TSTRING;

	-- drop if already exists
	SET @sql = 'DROP SYNONYM IF EXISTS ' + @schemaName + '.' + @SynonymName;
	EXEC (@sql);

	-- create synonym
	SET @sql = 'CREATE SYNONYM ' + @schemaName + '.' + @SynonymName + ' FOR ' + @ObjectName;
	EXEC (@sql);
END;