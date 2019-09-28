
CREATE PROC dbo.Init_cleanup
AS
BEGIN
    SET NOCOUNT ON;

	-- Protect production environment
	EXEC dsp.Util_protectProductionEnvironment
			
	-- Delete Junction Tables 

	-- Delete base tables 

	-- Delete Lookup tables (may not required)

END