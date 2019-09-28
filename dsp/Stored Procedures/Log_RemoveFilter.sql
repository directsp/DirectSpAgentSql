-- @filter if NULL then all filter will be removed
CREATE PROCEDURE dsp.Log_removeFilter
    @filter TSTRING = NULL
AS
BEGIN
	SET NOCOUNT ON;
	-- Enable the Log System
    IF ( dsp.Log_isEnabled() = 0 )
        EXEC dsp.Log_enable;

	-- Remove all filters
    IF ( @filter IS NULL )
    BEGIN
        DELETE  dsp.LogFilterSetting
        WHERE   logUserId = SYSTEM_USER;
        PRINT 'LogSystem> All filters have been removed.';
        RETURN 0;
    END;
	
	-- Remove the existing filter
    IF EXISTS ( SELECT 1 FROM dsp.LogFilterSetting AS LFS WHERE LFS.[filter] = @filter AND LFS.logUserId = SYSTEM_USER )
    BEGIN
        DELETE  dsp.LogFilterSetting 
        WHERE   [filter] = @filter AND logUserId = SYSTEM_USER;
        PRINT 'LogSystem> filter has been removed.';
        RETURN 0;
    END;
	
	-- Print not-find message
    PRINT 'LogSystem> Could not find the filter.';
END;