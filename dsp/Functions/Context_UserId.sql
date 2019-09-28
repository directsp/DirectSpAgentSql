
CREATE FUNCTION dsp.Context_userId (@context TCONTEXT)
RETURNS TSTRING
AS
BEGIN
    RETURN JSON_VALUE(@context, '$.userId');
END;