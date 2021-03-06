﻿CREATE PROCEDURE dsp.Log_addFilter
    @filter TSTRING = NULL,
    @isExclude BIT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET @isExclude = ISNULL(@isExclude, 0);

	-- Enable the Log System
	IF (dsp.Log_isEnabled() = 0)
		EXEC dsp.Log_enable;
	
	-- Clear Filters
	IF (@filter IS NULL AND @isExclude = 1)
	BEGIN
		DELETE dsp.LogFilterSetting WHERE logUserId = SYSTEM_USER AND [isExludedFilter] = 1;
		PRINT 'LogSystem> All exclude filters have been removed.';
		RETURN 0;
	END

	IF (@filter IS NULL AND @isExclude = 0)
	BEGIN
		DELETE dsp.LogFilterSetting WHERE logUserId = SYSTEM_USER AND [isExludedFilter] = 0;
		PRINT 'LogSystem> All include filters have been removed.';
		RETURN 0;
	END

	-- Insert or Update Filters
	IF EXISTS( SELECT 1 FROM dsp.LogFilterSetting AS LFS WHERE LFS.[filter] = @filter)
	BEGIN
		UPDATE dsp.LogFilterSetting SET [isExludedFilter] = @isExclude WHERE [filter] = @filter AND logUserId = SYSTEM_USER;
		PRINT 'LogSystem> filter has been updated.';
	END
	ELSE 
	BEGIN
		INSERT dsp.LogFilterSetting ( logUserId, [isExludedFilter], [filter] )
		VALUES  (SYSTEM_USER, @isExclude, @filter);
		PRINT 'LogSystem> filter has been added.';
	END

END