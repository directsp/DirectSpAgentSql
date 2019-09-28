CREATE PROC dsp.Init_cleanup
AS
BEGIN
    SET NOCOUNT ON;
    ----------------
    -- Check Production Environment and Run Cleanup
    ----------------
    EXEC dsp.Init_@cleanup @isProductionEnvironment = 0, @isWithCleanup = 1;

    -- Report it is done
    EXEC dsp.Log_trace @procId = @@PROCID, @message = 'System has been cleaned up!.';
END;















