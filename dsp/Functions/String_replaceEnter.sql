-- Create Function String
CREATE FUNCTION [dsp].[String_replaceEnter] (@value TSTRING)
RETURNS TSTRING
AS
BEGIN
	RETURN REPLACE(@value, N'\n', CHAR(/*No Codequality Error*/13) + CHAR(/*No Codequality Error*/10));
END;