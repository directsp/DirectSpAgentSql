CREATE PROCEDURE dsp.Table_setBlob
	@tableName TSTRING
as
BEGIN
	PRINT @tableName
		EXEC sys.sp_tableoption @TableNamePattern = @tableName, @OptionName = 'large value types out of row', @OptionValue = 'ON';
END