
/*
#MetaStart
{
	"DataAccessMode": "Write"
} 
#MetaEnd
*/
CREATE PROCEDURE api.User_CreateOrUpdateByAuthClaims
    @context TCONTEXT OUT, @AuthUserClaims TJSON
WITH EXECUTE AS OWNER
AS
BEGIN
    EXEC dsp.Context_Verify @context = @context OUTPUT, @procId = @@PROCID;
	
	DECLARE @exceptionId INT = dsp.ExceptionId_NotSupported();
    EXEC dsp.Exception_ThrowApp @procId = @@PROCID, @exceptionId = @exceptionId;
END