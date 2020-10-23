CREATE PROC dsp.Init_@start
    @isProductionEnvironment BIT = NULL, @isWithCleanup BIT = NULL, @reserved BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @reserved = ISNULL(@reserved, 1);

    ----------------
    -- Check Production Environment and Run Cleanup
    ----------------
    EXEC dsp.Init_@initSettings;
    EXEC dsp.Init_@cleanup @isProductionEnvironment = @isProductionEnvironment OUT, @isWithCleanup = @isWithCleanup OUT;
    EXEC dsp.Init_@initSettings;

    ----------------
    -- Recreate Strings
    ----------------
    IF (@reserved = 1) EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Recreating strings';
    DELETE  dsp.StringTable
     WHERE  1 = 1;
    EXEC dbo.Init_fillStrings;
    EXEC dsp.Init_@recreateStringFunctions;

    ----------------
    -- Recreate Exceptions 
    ----------------
    IF (@reserved = 1) EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Recreating exception';
    DELETE  dsp.Exception
     WHERE  1 = 1;
    EXEC dbo.Init_fillExceptions;

    -- make sure there is no invalid Exception Id for general application
    IF (EXISTS (SELECT  1 FROM  dsp.Exception AS E WHERE E.[exceptionId] < 56000))
        EXEC dsp.Exception_throw @procId = @@PROCID, @exceptionId = 55001, @message = 'Application exceptionId cannot be less than 56000!';

    EXEC dsp.Init_@createCommonExceptions;

    ----------------
    -- Lookups
    ----------------
    IF (@reserved = 1) --
        EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Filling lookups';
    EXEC dbo.Init_fillLookups;

    IF (@reserved = 1) EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Filling data';
    EXEC dbo.Init_fillData;

    -- Call Init again to make sure it can be called without cleanup
    IF (@isProductionEnvironment = 0 AND @isWithCleanup = 1 AND @reserved = 1)
    BEGIN
        EXEC dsp.Init_@start @isProductionEnvironment = 0, @isWithCleanup = 0, @reserved = 0;
        RETURN 0;
    END;

    -- Report it is done
    EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Init has been completed.';

END;