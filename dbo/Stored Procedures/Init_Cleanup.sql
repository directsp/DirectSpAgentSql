
CREATE PROC dbo.Init_Cleanup
AS
BEGIN
    SET NOCOUNT ON;

	-- Protect production environment
	EXEC dsp.Util_ProtectProductionEnvironment
			
	-- Delete Junction Tables 

	-- Delete base tables 

	-- Delete Lookup tables (may not required)

END