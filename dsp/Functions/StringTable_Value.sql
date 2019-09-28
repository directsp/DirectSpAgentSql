
CREATE FUNCTION [dsp].[StringTable_value] (@stringId TSTRING)
RETURNS TSTRING
AS
BEGIN
    DECLARE @value TSTRING;

    SELECT  @value = ST.stringValue
      FROM  dsp.StringTable AS ST
     WHERE  ST.stringId = @stringId;

    RETURN dsp.String_replaceEnter(@value);
END;