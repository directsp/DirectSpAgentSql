CREATE PROC dsp.Init
    @isProductionEnvironment BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @tranCount INT = @@TRANCOUNT;
    IF (@tranCount = 0)
        BEGIN TRANSACTION;
    BEGIN TRY
        EXEC dsp.Init_@start @isProductionEnvironment = @isProductionEnvironment, @isWithCleanup = NULL, @reserved = NULL;

        IF (@tranCount = 0) COMMIT;
    END TRY
    BEGIN CATCH
        IF (@tranCount = 0)
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;