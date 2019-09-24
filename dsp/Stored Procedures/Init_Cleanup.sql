CREATE PROC [dsp].[Init_Cleanup]
AS
BEGIN
    SET NOCOUNT ON;
    ----------------
    -- Check Production Environment and Run Cleanup
    ----------------
    EXEC dsp.[Init_$Cleanup] @isProductionEnvironment = 0, @isWithCleanup = 1;

    -- Report it is done
    EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'System has been cleaned up!.';
END;















