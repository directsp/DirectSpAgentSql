-- @filter if NULL then all filter will be removed
CREATE PROCEDURE [dsp].[Log_RemoveFilter]
    @filter TSTRING = NULL
AS
BEGIN
	SET NOCOUNT ON;
	-- Enable the Log System
    IF ( dsp.Log_IsEnabled() = 0 )
        EXEC dsp.Log_Enable;

	-- Remove all filters
    IF ( @filter IS NULL )
    BEGIN
        DELETE  dsp.LogFilterSetting
        WHERE   [userName] = SYSTEM_USER;
        PRINT 'LogSystem> All filters have been removed.';
        RETURN 0;
    END;
	
	-- Remove the existing filter
    IF EXISTS ( SELECT 1 FROM dsp.LogFilterSetting AS LFS WHERE LFS.[filter] = @filter AND LFS.[userName] = SYSTEM_USER )
    BEGIN
        DELETE  dsp.LogFilterSetting 
        WHERE   [filter] = @filter AND [userName] = SYSTEM_USER;
        PRINT 'LogSystem> filter has been removed.';
        RETURN 0;
    END;
	
	-- Print not-find message
    PRINT 'LogSystem> Could not find the filter.';
END;