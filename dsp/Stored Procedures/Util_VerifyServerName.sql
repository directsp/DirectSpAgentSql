CREATE PROC [dsp].[Util_VerifyServerName]
	@confirmServerName TSTRING
AS
BEGIN
	DECLARE @serverName TSTRING = @@sERVERNAME;
	IF (@confirmServerName IS NULL OR	LOWER(@confirmServerName) != LOWER(@@sERVERNAME))
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = N'confirmServerName must be set to ''{0}''!',
			@param0 = @serverName;
END;