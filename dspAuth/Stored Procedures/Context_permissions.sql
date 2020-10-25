CREATE PROCEDURE dspAuth.Context_permissions
    @context TCONTEXT OUT, @objectId BIGINT, @objectTypeId INT, @permissions TSTRING = NULL OUT
AS
BEGIN
    DECLARE @userId INT;
    EXEC dsp.Context_props @context = @context OUT, @userId = @userId OUT;

    EXEC dspAuth.SecurityDescriptor_userPermissions @objectId = @objectId, @objectTypeId = @objectTypeId, --
        @userId = @userId, @permissions = @permissions OUTPUT;
END;