
/*
#MetaStart
{
	"dataAccessMode": "write"
} 
#MetaEnd
*/
CREATE PROCEDURE api.User_CreateOrUpdateByAuthClaims
    @context TCONTEXT OUT, @authUserClaims TJSON
WITH EXECUTE AS OWNER
AS
BEGIN
    EXEC dsp.Context_Verify @context = @context OUTPUT, @procId = @@PROCID;
	
	DECLARE @exceptionId INT = dsp.ExceptionId_NotSupported();
    EXEC dsp.Exception_Throw @procId = @@PROCID, @exceptionId = @exceptionId, @message = @authUserClaims;
END