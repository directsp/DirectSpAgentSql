
CREATE PROC [dsp].[Util_ProtectProductionEnvironment]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @isProductionEnvironment BIT;
    EXEC dsp.Setting_Props @isProductionEnvironment = @isProductionEnvironment OUTPUT;
    IF (@isProductionEnvironment = 1) --
        EXEC dsp.Exception_ThrowAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = 'This operation can not be executed in ProductionEnvironment!';
END;