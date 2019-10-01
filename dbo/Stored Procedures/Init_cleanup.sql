
CREATE PROC dbo.Init_cleanup
AS
BEGIN
    SET NOCOUNT ON;

    -- Protect production environment
    EXEC dsp.Util_protectProductionEnvironment;

	-- uncomment the following code to delete all records in your database in development environment
	 EXEC dsp.Init_deleteAllDatabaseRecords @serverName = @@SERVERNAME

END;