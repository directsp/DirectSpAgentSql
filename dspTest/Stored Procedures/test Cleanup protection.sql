
CREATE PROCEDURE dspTest.[test Cleanup protection]
AS
BEGIN
    DECLARE @msg TSTRING;
    DECLARE @isProductionEnvironment BIT;
    EXEC dsp.Setting_props @isProductionEnvironment = @isProductionEnvironment OUT;

    -----------
    -- check: can not running test in production
    -----------
    IF (@isProductionEnvironment = 1) --
        EXEC tSQLt.Fail @Message0 = N'Can not run this test on ProductionEnvironment';

    -----------
    -- check: exception is expected if @isAutoCleanup is false and init called in production
    -----------
    SAVE TRANSACTION Test;
    EXEC dsp.Setting_propsSet @isAutoCleanup = 1, @isProductionEnvironment = 1;
    BEGIN TRY
        EXEC dsp.Init;
        EXEC tSQLt.Fail @Message0 = N'Exception expected if @isAutoCleanup is false';
    END TRY
    BEGIN CATCH
    END CATCH;
    ROLLBACK TRANSACTION Test;

    -----------
    -- check: exception is expected if try to remove @isProductionEnvironment in init
    -----------
    SAVE TRANSACTION Test;
    EXEC dsp.Setting_propsSet @isAutoCleanup = 0, @isProductionEnvironment = 1;
    BEGIN TRY
        EXEC dsp.Init @isProductionEnvironment = 0;
        EXEC tSQLt.Fail @Message0 = N'Exception expected if try to remove @isProductionEnvironment in init';
    END TRY
    BEGIN CATCH
    END CATCH;
    ROLLBACK TRANSACTION Test;

    
	-----------
    /* check: */ SET @msg = 'if @isAutoCleanup is false, dsp.init should not delete records';
    -----------
    SAVE TRANSACTION Test;
    EXEC dsp.Setting_propsSet @isAutoCleanup = 0, @isProductionEnvironment = 1;

    INSERT INTO dsp.Setting (settingId, appName)
    VALUES (5555, N'ZooZoo');

    EXEC dsp.Init;

    IF ((SELECT COUNT(1) FROM   dsp.Setting) = 1) EXEC tSQLt.Fail @Message0 = @msg;
    ROLLBACK TRANSACTION Test;

    -----------
    /* check: */ SET @msg = 'if @isAutoCleanup is true, dsp.init should delete records';
    -----------
	EXEC dsp.Log_trace @procId = @@PROCID, @message = @msg;
    SAVE TRANSACTION Test;
    EXEC dsp.Setting_propsSet @isAutoCleanup = 1, @isProductionEnvironment = 0;
	
    INSERT INTO dsp.Setting (settingId, appName)
    VALUES (5555, N'ZooZoo');

    EXEC dsp.Init;

    IF ((SELECT COUNT(1) FROM   dsp.Setting) > 1) EXEC tSQLt.Fail @Message0 = @msg;
    ROLLBACK TRANSACTION Test;

    -----------
    -- check: autoCleanUp must be set after cleanuup
    -----------
    --SAVE TRANSACTION Test;
    --EXEC dsp.Setting_propsSet @isAutoCleanup = 1, @isProductionEnvironment = 0;
    --EXEC dsp.Init;
    --ROLLBACK TRANSACTION Test;

END;