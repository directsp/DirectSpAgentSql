CREATE PROCEDURE [dsp].[SetIfChanged_Int]
    @procId INT, @propName TSTRING, @newValue BIGINT, @oldValue BIGINT OUT, @hasAccess BIT = NULL, @nullAsNotSet BIT = 0, @isUpdated BIT = NULL OUT
AS
BEGIN
	SET @hasAccess = ISNULL(@hasAccess, 1);
    IF (dsp.Param_IsChanged(@oldValue, @newValue, @nullAsNotSet) = 0)
        RETURN 0;

    IF (@hasAccess = 0) --
        EXEC dsp.Exception_ThrowAccessDeniedOrObjectNotExists @procId = @procId, @message = 'propName: {0}', @param0 = @propName;

    SET @isUpdated = 1;
    SET @oldValue = @newValue;
END;







