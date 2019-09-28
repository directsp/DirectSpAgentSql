CREATE PROC [dsp].[Util_verifyServerName]
	@confirmServerName TSTRING
AS
BEGIN
	DECLARE @serverName TSTRING = @@sERVERNAME;
	IF (@confirmServerName IS NULL OR	LOWER(@confirmServerName) != LOWER(@@sERVERNAME))
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = N'confirmServerName must be set to ''{0}''!',
			@param0 = @serverName;
END;