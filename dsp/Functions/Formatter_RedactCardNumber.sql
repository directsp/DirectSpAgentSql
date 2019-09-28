CREATE FUNCTION [dsp].[Formatter_redactCardNumber] (@cardNumber TSTRING)
RETURNS TSTRING
AS
BEGIN
    SET @cardNumber = dsp.Formatter_formatString(@cardNumber);
    RETURN LEFT(@cardNumber, 6) + REPLICATE('x', LEN(@cardNumber) - 6 - 4) + RIGHT(@cardNumber, 4);
END;



