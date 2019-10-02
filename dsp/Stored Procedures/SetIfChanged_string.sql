CREATE PROCEDURE dsp.SetIfChanged_string
    @procId INT, @propName TSTRING, @newValue TSTRING, @oldValue TSTRING OUT, @hasAccess BIT = NULL, @nullAsNotSet BIT = 0, @isUpdated BIT OUT
AS
BEGIN
    SET @hasAccess = ISNULL(@hasAccess, 1);

    IF (dsp.Param_isChanged(dsp.Convert_toSqlVariant(@oldValue), dsp.Convert_toSqlVariant(@newValue), @nullAsNotSet) = 0)
        RETURN 0;

    IF (@hasAccess = 0) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @procId, @message = 'propName: {0}', @param0 = @propName;

    SET @isUpdated = 1;
    SET @oldValue = @newValue;
END;