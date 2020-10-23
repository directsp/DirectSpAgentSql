
/*
#MetaStart
{
	"dataAccessMode": "readSnapshot"
} 
#MetaEnd
*/
CREATE PROCEDURE api.Test_info
    @context TCONTEXT OUTPUT, @param1 TSTRING, @param2 TSTRING, @result TSTRING = NULL OUT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    EXEC dsp.Context_verify @context = @context OUT, @procId = @@PROCID;

    -- All users should have access to this procedure
    SET @result = @param1 + @param2 + 'OK';
END;