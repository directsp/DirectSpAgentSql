
CREATE PROC dsp.Init_deleteAllDatabaseRecords
    @serverName TSTRING
AS
BEGIN
    SET NOCOUNT ON;

    -- Protect production environment
    EXEC dsp.Util_protectProductionEnvironment;

    -- check confirm
    IF (@serverName <> @@SERVERNAME) --
        EXEC dsp.Exception_throwInvalidArgument @procId = @@PROCID, @argumentName = 'confirm', @argumentValue = @serverName,
            @message = 'serverName paramter must be: {0}', @param0 = @@SERVERNAME;

    -- uncomment the following code to delete all records in your database in development environment
    DECLARE @tranCount INT = @@TRANCOUNT;
    IF (@tranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY

        DECLARE @whereand TSTRING = N'AND o.name NOT IN ( ''sysdiagrams'', ''LogUser'', ''LogFilterSetting'')';
        EXEC sys.sp_MSforeachtable @command1 = N'ALTER TABLE ? NOCHECK CONSTRAINT ALL', @whereand = @whereand;
        EXEC sys.sp_MSforeachtable @command1 = N'DELETE FROM ?', @whereand = @whereand;

        IF (@tranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@tranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

END;