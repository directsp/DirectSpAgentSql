
CREATE PROCEDURE [tCodeQuality].[test description must be nvarchar(max)]
AS
BEGIN
	DECLARE @msg TSTRING;
	SELECT	@msg = QUOTENAME(SCHEMA_NAME(tb.schema_id)) + '.' + QUOTENAME(OBJECT_NAME(tb.object_id))
	FROM		sys.columns C
			INNER JOIN sys.tables tb ON tb.object_id = C.object_id
			INNER JOIN sys.types T ON C.system_type_id = T.user_type_id
	WHERE	tb.is_ms_shipped = 0
			AND C.name LIKE N'%description%'
			AND (T.name != 'nvarchar'
				OR	C.max_length != -1);

	IF (@msg IS NOT NULL)
	BEGIN
		SET @msg = '"description and type TSTRING" was not found in table ' + @msg;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;
END;