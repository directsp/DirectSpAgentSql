CREATE PROCEDURE [dsp].[String_Tokenize]
	@expression TSTRING, @delimeter TSTRING, @position INT OUTPUT, @token TSTRING OUTPUT
AS
BEGIN
	IF (@position = 0)
	BEGIN
		SET @token = NULL;
		RETURN 0;
	END;
	
	SET @delimeter = ISNULL(@delimeter, '/');
	
	SET @position = ISNULL(@position, 1);
	DECLARE @delimiterIndex INT = CHARINDEX(@delimeter, @expression, @position);
	IF (@delimiterIndex = 0)
		SET @delimiterIndex = LEN(@expression) - @delimiterIndex + 1;

	SET @token = SUBSTRING(@expression, @position, @delimiterIndex - @position);
	
	SET @position = @delimiterIndex + 1;
	IF (@position > LEN(@expression))
		SET @position = 0;
END;