CREATE  PROC [dspAuth].[Role_delete]
	@auditUserId INT, @roleId INT
AS
BEGIN
	-- Checking if there is a role with roleId: @roleId
	EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Checking if there is a role with roleId: {0}', @param0 = @roleId;
	DECLARE @actualRoleId INT;
	SELECT	@actualRoleId = R.roleId
	FROM dspAuth.Role AS R
	WHERE	R.roleId = @roleId;

	IF (@actualRoleId IS NULL) --
		EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = N'There is no Role with roleId: {0}', @param0 = @roleId;

	DECLARE @tranCount INT = @@TRANCOUNT;
	IF (@tranCount = 0)
		BEGIN TRANSACTION;
	BEGIN TRY
		-- Updating Role before deleting it
		EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Updating Role before deleting it';
		UPDATE	dspAuth.Role
		SET modifiedByUserId = @auditUserId
		WHERE	roleId = @roleId;

		-- Deleting with roleId: @roleId
		EXEC dsp.Log_trace @procId = @@PROCID, @message = N'Deleting with roleId: {0}', @param0 = @roleId;
		DELETE dspAuth.Role
		WHERE	roleId = @roleId;

		IF (@tranCount = 0) COMMIT;
	END TRY
	BEGIN CATCH
		IF (@tranCount = 0)
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
END;