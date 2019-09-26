CREATE FUNCTION [dsp].[Path_RemoveExtension] (
	@path TSTRING)
RETURNS TSTRING
BEGIN
	RETURN LEFT(@path, LEN(@path) - CHARINDEX('.', REVERSE(@path)));
END;