﻿CREATE FUNCTION tCodeQuality.Test_@removeWhitespacesBig ( @string TBIGSTRING )
RETURNS TBIGSTRING
AS
BEGIN
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(@string, ' ', '.'), CHAR(13), '.'), CHAR(10), '.'), CHAR(9), '.');
END;