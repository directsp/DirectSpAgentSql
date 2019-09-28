CREATE PROCEDURE [dsp].[SetIfChanged_decimal]
    @procId INT, @propName TSTRING, @newValue DECIMAL, @oldValue DECIMAL OUT, @hasAccess BIT = 1, @nullAsNotSet BIT = 0, @isUpdated BIT OUT
AS
BEGIN
    SET @hasAccess = ISNULL(@hasAccess, 0);

    IF (dsp.Param_isChanged(@oldValue, @newValue, @nullAsNotSet) = 0)
        RETURN 0;

    IF (@hasAccess = 0) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @procId, @message = 'propName: {0}', @param0 = @propName;

    SET @isUpdated = 1;
    SET @oldValue = @newValue;
END;