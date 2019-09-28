CREATE	PROCEDURE dsp.Context_@validatePagination
	@recordCount INT OUT, @recordIndex INT OUT
AS
BEGIN
	-- Get RecordCount and RecordIndex from Context
	SET @recordIndex = ISNULL(@recordIndex, 0);

	DECLARE @paginationMaxRecordCount INT;
	DECLARE @paginationDefaultRecordCount INT;
	EXEC dsp.Setting_props @paginationDefaultRecordCount = @paginationDefaultRecordCount OUTPUT,
		@paginationMaxRecordCount = @paginationMaxRecordCount OUTPUT;

	-- Set Default
	IF (dsp.Param_isSetOrNotNull(@recordCount) = 0)
		SET @recordCount = @paginationDefaultRecordCount;

	-- Set Max
	IF (@recordCount = -2)
		SET @recordCount = @paginationMaxRecordCount;

	IF (@recordCount > @paginationMaxRecordCount) --
	BEGIN
		DECLARE @exceptionId INT = dsp.ExceptionId_pageSizeTooLarge();
		EXEC dsp.Exception_throw @procId = @@PROCID, @exceptionId = @exceptionId;
	END
END;