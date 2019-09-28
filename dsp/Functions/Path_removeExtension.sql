CREATE FUNCTION [dsp].[Path_removeExtension] (
	@path TSTRING)
RETURNS TSTRING
BEGIN
	RETURN LEFT(@path, LEN(@path) - CHARINDEX('.', REVERSE(@path)));
END;