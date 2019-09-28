CREATE PROCEDURE [dsp].[SetIfChanged_float]
    @procId INT, @propName TSTRING, @newValue FLOAT, @oldValue FLOAT OUT, @hasAccess BIT = 1, @nullAsNotSet BIT = 0, @isUpdated BIT OUT
AS
BEGIN
    SET @hasAccess = ISNULL(@hasAccess, 1);
    IF (dsp.Param_isChanged(@oldValue, @newValue, @nullAsNotSet) = 0)
        RETURN 0;

    IF (@hasAccess = 0) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @procId, @message = 'propName: {0}', @param0 = @propName;

    SET @isUpdated = 1;
    SET @oldValue = @newValue;
END;





