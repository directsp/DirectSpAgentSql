CREATE FUNCTION [dsp].[Formatter_FormatMobileNumber] ( @mobileNumber TSTRING )
RETURNS TSTRING
BEGIN
    SET @mobileNumber = REPLACE(@mobileNumber, ' ', '');
    SET @mobileNumber = REPLACE(@mobileNumber, '-', '');
    SET @mobileNumber = REPLACE(@mobileNumber, '.', '');
    
	-- 9124445566
    IF ( LEN(@mobileNumber) = 10 )
        SET @mobileNumber = '+98' + @mobileNumber;

	-- 09124445566
    IF ( LEN(@mobileNumber) = 11 AND SUBSTRING(@mobileNumber, 1, 1) = '0' )
        SET @mobileNumber = '+98' + SUBSTRING(@mobileNumber, 2, 10);

	-- 989124445566
    IF ( LEN(@mobileNumber) > 10 AND SUBSTRING(@mobileNumber, 1, 1) <> '+' )
        SET @mobileNumber = '+' + @mobileNumber;

	-- Remove plus
    SET @mobileNumber = SUBSTRING(@mobileNumber, 2, LEN(@mobileNumber) - 1);

	-- checking length >=11 amd <=13
    IF ( LEN(@mobileNumber) NOT BETWEEN 11 AND 13 )
        RETURN NULL;

    IF ( @mobileNumber LIKE '%[^0-9]%'  )
        SET @mobileNumber = NULL;

    RETURN @mobileNumber;
END;