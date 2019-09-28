CREATE FUNCTION [dsp].[DateTime_fromUnixTimeStamp] (
@unixTime BIGINT
)
RETURNS datetime
AS
BEGIN

  RETURN DATEADD(S,@unixTime,'1970-01-01')

END