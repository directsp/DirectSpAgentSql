CREATE PROCEDURE [dspAuth].[Validate_checkAccess]
    @context TCONTEXT OUT, @procId INT, @permissions TSTRING, @permissionId INT, @throwIfNotAccess BIT = 1, @hasPermission BIT = NULL OUT
AS
BEGIN
    -- Prepare input
    SET @throwIfNotAccess = ISNULL(@throwIfNotAccess, 1);
    SET @permissions = STUFF(@permissions, 1, 1, ',');
    SET @permissions = STUFF(@permissions, LEN(@permissions), 1, ',');
    DECLARE @permissionTemplate TSTRING = ',' + dsp.Convert_toString(@permissionId) + ',';

    -- Check access
    SET @hasPermission = IIF(CHARINDEX(@permissionTemplate, @permissions) > 0, 1, 0);

    -- Throw exception
    IF (@hasPermission = 0 AND  @throwIfNotAccess = 1) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @procId;
END;