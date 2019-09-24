
CREATE PROC [dsp].[Validate_CheckNotNull]
	@procId INT, @ArgumentName TSTRING, @ArgumentValue TSTRING
AS
BEGIN
	IF (@ArgumentValue IS NULL) --
		EXEC dsp.[Exception_ThrowInvalidArgument] @procId = @procId, @argumentName = @ArgumentName, @argumentValue = @ArgumentValue;
END;