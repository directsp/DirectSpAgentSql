
-- #Inliner {"InlineMode":"none"} 
CREATE FUNCTION [dsp].[Convert_binaryFromBase64](@base64 TSTRING)
RETURNS VARBINARY(MAX)
AS
BEGIN
    DECLARE @bin VARBINARY(MAX)
    /*
        SELECT CONVERT(TSTRING, dbo.f_Base64ToBinary('Q29udmVydGluZyB0aGlzIHRleHQgdG8gQmFzZTY0Li4u'))
    */
    SET @bin = CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@base64"))', 'VARBINARY(MAX)')
    RETURN @bin
END