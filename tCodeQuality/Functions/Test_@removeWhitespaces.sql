CREATE FUNCTION tCodeQuality.Test_@removeWhitespaces ( @string TSTRING )
RETURNS TSTRING
AS
BEGIN
    RETURN LOWER(REPLACE(REPLACE(REPLACE(REPLACE(@string, ' ', '.'), CHAR(13), '.'), CHAR(10), '.'), CHAR(9), '.'));
END;