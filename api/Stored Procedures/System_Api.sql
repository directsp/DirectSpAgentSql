
/*
#MetaStart
{
	"dataAccessMode": "readSnapshot"
} 
#MetaEnd
*/
CREATE PROCEDURE [api].[System_api]
	@context TCONTEXT OUTPUT, @api TJSON = NULL OUT
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;
	EXEC dsp.Context_verify @context = @context OUT, @procId = @@PROCID;

	-- All users should have access to this procedure

	-- Call dsp
	EXEC dsp.System_api @api = @api OUTPUT;
END;