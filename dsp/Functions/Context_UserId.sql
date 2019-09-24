
CREATE FUNCTION [dsp].[Context_UserId] (@context TCONTEXT)
RETURNS TSTRING
AS
BEGIN
    RETURN JSON_VALUE(@context, '$.userId');
END;