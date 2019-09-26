
CREATE FUNCTION [dsp].[StringTable_Value] (@stringId TSTRING)
RETURNS TSTRING
AS
BEGIN
    DECLARE @Value TSTRING;

    SELECT  @Value = ST.stringValue
      FROM  dsp.StringTable AS ST
     WHERE  ST.stringId = @stringId;

    RETURN dsp.String_ReplaceEnter(@Value);
END;