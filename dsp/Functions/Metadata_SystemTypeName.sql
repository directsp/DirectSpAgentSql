CREATE FUNCTION [dsp].[Metadata_SystemTypeName] (@typeName TSTRING)
RETURNS TSTRING
AS
BEGIN
	DECLARE @systemName TSTRING = @typeName;

	IF EXISTS (SELECT		1
					FROM	sys.types AS T
				WHERE	T.name = @systemName AND T.is_user_defined = 1)
	BEGIN
		SELECT	DISTINCT @systemName = bt.name
		FROM	sys.syscolumns c
				INNER JOIN sys.systypes st ON st.xusertype = c.xusertype
				INNER JOIN sys.systypes bt ON bt.xusertype = c.xtype
		WHERE	st.name = @typeName;
	END;

	RETURN @systemName;
END;