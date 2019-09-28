
CREATE PROC [dsp].[Validate_checkNotNull]
	@procId INT, @argumentName TSTRING, @argumentValue TSTRING
AS
BEGIN
	IF (@argumentValue IS NULL) --
		EXEC dsp.[Exception_throwInvalidArgument] @procId = @procId, @argumentName = @argumentName, @argumentValue = @argumentValue;
END;