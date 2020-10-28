
-- #Inliner {"InlineMode":"none"} 
CREATE FUNCTION [dsp].[Convert_binaryToBase64] (@bin VARBINARY(8000))
RETURNS TSTRING
AS
BEGIN
    RETURN 'aa';--dsp.Convert_binaryToBase64Max(CAST(@bin AS VARBINARY(MAX)));
END;