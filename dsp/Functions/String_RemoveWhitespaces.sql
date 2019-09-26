CREATE FUNCTION [dsp].[String_RemoveWhitespaces] ( @string TSTRING )
RETURNS TSTRING
AS
BEGIN
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(@string, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '');
END;