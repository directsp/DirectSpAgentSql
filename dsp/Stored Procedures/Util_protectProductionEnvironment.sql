
CREATE PROC [dsp].[Util_protectProductionEnvironment]
AS
BEGIN
    DECLARE @isProductionEnvironment BIT;
    EXEC dsp.Setting_props @isProductionEnvironment = @isProductionEnvironment OUTPUT;
    IF (@isProductionEnvironment = 1) --
        EXEC dsp.Exception_throwAccessDeniedOrObjectNotExists @procId = @@PROCID, @message = 'This operation can not be executed in ProductionEnvironment!';
END;