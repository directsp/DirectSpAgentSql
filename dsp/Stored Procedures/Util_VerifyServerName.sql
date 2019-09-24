CREATE PROC [dsp].[Util_VerifyServerName]
	@ConfirmServerName TSTRING
AS
BEGIN
	DECLARE @ServerName TSTRING = @@SERVERNAME;
	IF (@ConfirmServerName IS NULL OR	LOWER(@ConfirmServerName) != LOWER(@@SERVERNAME))
		EXEC err.ThrowGeneralException @procId = @@PROCID, @message = N'ConfirmServerName must be set to ''{0}''!',
			@param0 = @ServerName;
END;