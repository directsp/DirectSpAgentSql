CREATE PROCEDURE [dsp].[Util_createRandomString]
    @length INT,
    @includeLetter BIT = 1 ,
    @includeDigit BIT = 1 ,
    @randomString TSTRING OUT
AS
BEGIN
    DECLARE @counter INT;
    DECLARE @nextChar CHAR(1);
    SET @counter = 1;
    SET @randomString = '';

    WHILE @counter <= @length
    BEGIN
	   IF (@includeLetter=1 AND @includeDigit=1)  SET  @nextChar = CHAR(48 + CONVERT(INT, ( 122 - 48  + 1 ) * RAND())); -- 0 to z
	   ELSE IF (@includeLetter=1)  SET  @nextChar = CHAR(65 + CONVERT(INT, ( 122 - 65 + 1 ) * RAND())); -- a to z
	   ELSE IF (@includeDigit=1)  SET  @nextChar = CHAR(48 + CONVERT(INT, ( 57 - 48 + 1 ) * RAND())); -- 0 to 9
	   ELSE RETURN NULL

        IF ASCII(@nextChar) NOT IN ( 58, 59, 60, 61, 62, 63, 64, 91, 92, 93, 94, 95, 96 )
        BEGIN
            SELECT  @randomString = @randomString + @nextChar;
            SET @counter = @counter + 1;
        END;
    END;
END;