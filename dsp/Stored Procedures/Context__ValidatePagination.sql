CREATE	PROCEDURE [dsp].[Context_$ValidatePagination]
	@recordCount INT OUT, @recordIndex INT OUT
AS
BEGIN
	-- Get RecordCount and RecordIndex from Context
	SET @recordIndex = ISNULL(@recordIndex, 0);

	DECLARE @paginationMaxRecordCount INT;
	DECLARE @paginationDefaultRecordCount INT;
	EXEC dsp.Setting_Props @paginationDefaultRecordCount = @paginationDefaultRecordCount OUTPUT,
		@paginationMaxRecordCount = @paginationMaxRecordCount OUTPUT;

	-- Set Default
	IF (dsp.Param_IsSetOrNotNull(@recordCount) = 0)
		SET @recordCount = @paginationDefaultRecordCount;

	-- Set Max
	IF (@recordCount = -2)
		SET @recordCount = @paginationMaxRecordCount;

	IF (@recordCount > @paginationMaxRecordCount) --
	BEGIN
		DECLARE @exceptionId INT = dsp.ExceptionId_PageSizeTooLarge();
		EXEC dsp.Exception_Throw @procId = @@PROCID, @exceptionId = @exceptionId;
	END
END;