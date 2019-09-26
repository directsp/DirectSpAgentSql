
CREATE FUNCTION [dsp].[StringTable_Value] (@stringId TSTRING)
RETURNS TSTRING
AS
BEGIN
    DECLARE @value TSTRING;

    SELECT  @value = ST.stringValue
      FROM  dsp.StringTable AS ST
     WHERE  ST.stringId = @stringId;

    RETURN dsp.String_ReplaceEnter(@value);
END;