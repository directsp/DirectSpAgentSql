CREATE PROCEDURE [dsp].[SetIfChanged_Time]
    @procId INT, @PropName TSTRING, @NewValue DATETIME, @OldValue DATETIME OUT, @HasAccess BIT = NULL, @NullAsNotSet BIT = 0, @IsUpdated BIT OUT
AS
BEGIN
    SET @HasAccess = ISNULL(@HasAccess, 1);

    IF (dsp.Param_IsChanged(@OldValue, @NewValue, @NullAsNotSet) = 0)
        RETURN;

    IF (@HasAccess = 0) --
        EXEC err.ThrowAccessDeniedOrObjectNotExists @procId = @procId, @message = 'PropName: {0}', @param0 = @PropName;

    SET @IsUpdated = 1;
    SET @OldValue = @NewValue;
END;


