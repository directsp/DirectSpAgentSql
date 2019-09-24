
/*
#MetaStart
{
	"DataAccessMode": "ReadSnapshot"
} 
#MetaEnd
*/
CREATE PROCEDURE [api].[System_Api]
	@context TCONTEXT OUTPUT, @Api TJSON = NULL OUT
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;
	EXEC dsp.Context_Verify @context = @context OUT, @procId = @@PROCID;

	-- Any user should have access to this procedure

	-- Call dsp
	EXEC dsp.System_Api @Api = @Api OUTPUT;
END;