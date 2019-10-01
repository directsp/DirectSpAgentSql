CREATE PROCEDURE [dspAuth].[Permission_props]
    @permissionId INT,
    @permissionName TSTRING OUT
AS
BEGIN
    SELECT  @permissionName = P.permissionName
    FROM    dspAuth.Permission AS P
    WHERE   P.permissionId = @permissionId;
END;