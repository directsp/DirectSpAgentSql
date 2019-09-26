
CREATE PROC [dsp].[Validate_CheckNotNull]
	@procId INT, @argumentName TSTRING, @argumentValue TSTRING
AS
BEGIN
	IF (@argumentValue IS NULL) --
		EXEC dsp.[Exception_ThrowInvalidArgument] @procId = @procId, @argumentName = @argumentName, @argumentValue = @argumentValue;
END;