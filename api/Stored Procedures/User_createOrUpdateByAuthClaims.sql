
/*
#MetaStart
{
	"dataAccessMode": "write"
} 
#MetaEnd
*/
CREATE PROCEDURE api.User_createOrUpdateByAuthClaims
    @context TCONTEXT OUT, @authUserClaims TJSON
WITH EXECUTE AS OWNER
AS
BEGIN
    EXEC dsp.Context_verify @context = @context OUTPUT, @procId = @@PROCID;
	
	DECLARE @exceptionId INT = dsp.ExceptionId_notSupported();
    EXEC dsp.Exception_throw @procId = @@PROCID, @exceptionId = @exceptionId, @message = @authUserClaims;
END