CREATE PROCEDURE [dspAuth].[Context_permissions]
    @context TCONTEXT OUT, @objectId BIGINT, @objectTypeId INT, @permissions TSTRING = NULL OUT
AS
BEGIN
	DECLARE @contextUserId INT = dsp.Context_userId(@context);

    EXEC dspAuth.SecurityDescriptor_userPermissions @objectId = @objectId, @objectTypeId = @objectTypeId, @userId = @contextUserId,
        @permissions = @permissions OUTPUT;
END;