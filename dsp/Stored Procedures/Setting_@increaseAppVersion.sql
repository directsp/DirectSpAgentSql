CREATE PROC dsp.Setting_@increaseAppVersion
    @appVersion TSTRING OUT, @forceIncrease INT
AS
BEGIN
    DECLARE @position INT;
    DECLARE @part1 TSTRING;
    DECLARE @part2 TSTRING;
    DECLARE @part3 TSTRING;
    EXEC dsp.String_tokenize @expression = @appVersion, @delimeter = N'.', @position = @position OUTPUT, @token = @part1 OUTPUT;
    EXEC dsp.String_tokenize @expression = @appVersion, @delimeter = N'.', @position = @position OUTPUT, @token = @part2 OUTPUT;
    EXEC dsp.String_tokenize @expression = @appVersion, @delimeter = N'.', @position = @position OUTPUT, @token = @part3 OUTPUT;

    SET @position = NULL;
    DECLARE @oldPart1 TSTRING;
    DECLARE @oldPart2 TSTRING;
    DECLARE @oldPart3 TSTRING;
    DECLARE @oldAppVersion TSTRING;
    EXEC dsp.Setting_props @appVersion = @oldAppVersion OUT;
    EXEC dsp.String_tokenize @expression = @oldAppVersion, @delimeter = N'.', @position = @position OUTPUT, @token = @oldPart1 OUTPUT;
    EXEC dsp.String_tokenize @expression = @oldAppVersion, @delimeter = N'.', @position = @position OUTPUT, @token = @oldPart2 OUTPUT;
    EXEC dsp.String_tokenize @expression = @oldAppVersion, @delimeter = N'.', @position = @position OUTPUT, @token = @oldPart3 OUTPUT;

	-- Check Star
    IF (@part3 = N'*' OR @forceIncrease = 1)
	BEGIN
		SET @part3 = ISNULL(@oldPart3, N'0');
        SET @part3 = dsp.Convert_toString(CAST(@part3 AS INT) + 1);
	END

    -- Check format
    SET @appVersion = @part1 + '.' + @part2 + '.' + @part3;
END;