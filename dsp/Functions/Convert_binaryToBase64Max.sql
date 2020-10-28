CREATE FUNCTION [dsp].[Convert_binaryToBase64Max](@bin VARBINARY(MAX))
RETURNS TSTRING
AS
BEGIN
    DECLARE @base64 TSTRING
    /*
        SELECT dbo.f_BinaryToBase64(CONVERT(VARBINARY(MAX), 'Converting this text to Base64...'))
    */
    SET @base64 = CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:variable("@bin")))','TSTRING')
    RETURN @base64
END