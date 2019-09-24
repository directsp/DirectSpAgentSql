CREATE PROCEDURE [dsp].[SetIfChanged_Money]
    @procId INT, @PropName TSTRING, @NewValue MONEY, @OldValue MONEY OUT, @HasAccess BIT = 1, @NullAsNotSet BIT = 0, @IsUpdated BIT OUT
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




