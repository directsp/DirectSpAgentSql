
/*
#MetaStart
{
	"dataAccessMode": "readSnapshot"
} 
#MetaEnd
*/
CREATE PROCEDURE [api].[System_Api]
	@context TCONTEXT OUTPUT, @api TJSON = NULL OUT
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;
	EXEC dsp.Context_Verify @context = @context OUT, @procId = @@PROCID;

	-- All users should have access to this procedure

	-- Call dsp
	EXEC dsp.System_Api @api = @api OUTPUT;
END;