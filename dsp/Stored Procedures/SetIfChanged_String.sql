CREATE PROCEDURE [dsp].[SetIfChanged_String]
    @procId INT, @PropName TSTRING, @NewValue TSTRING, @OldValue TSTRING OUT, @HasAccess BIT = NULL, @NullAsNotSet BIT = 0, @IsUpdated BIT OUT
AS
BEGIN
    SET @HasAccess = ISNULL(@HasAccess, 1);

    IF (dsp.Param_IsChanged(dsp.Convert_ToSqlvariant(@OldValue), dsp.Convert_ToSqlvariant(@NewValue), @NullAsNotSet) = 0)
        RETURN;

    IF (@HasAccess = 0) --
        EXEC err.ThrowAccessDeniedOrObjectNotExists @procId = @procId, @message = 'PropName: {0}', @param0 = @PropName;

    SET @IsUpdated = 1;
    SET @OldValue = @NewValue;
END;





