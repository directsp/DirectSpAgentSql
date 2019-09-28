CREATE FUNCTION [dsp].[Formatter_removeLikeInjection] (
	@value TSTRING)
RETURNS TSTRING
AS
BEGIN
	SET @value = dsp.Formatter_formatString(@value);
	SET @value = REPLACE(@value, '%', '');
	SET @value = REPLACE(@value, '[', '');
	SET @value = REPLACE(@value, '_', '[_]');

	RETURN @value;
END;