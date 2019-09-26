CREATE FUNCTION [dsp].[Formatter_RemoveLikeInjection] (
	@value TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @value = dsp.Formatter_FormatString(@value);
	SET @value = REPLACE(@value, '%', '');
	SET @value = REPLACE(@value, '[', '');
	SET @value = REPLACE(@value, '_', '[_]');

	RETURN @value;
END;