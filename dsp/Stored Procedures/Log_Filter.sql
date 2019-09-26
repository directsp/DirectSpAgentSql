CREATE PROCEDURE [dsp].[Log_Filter]
	@filter TSTRING = NULL
AS
BEGIN
	SET @filter = NULLIF(@filter, '');

	-- remove all old filters
	EXEC dsp.Log_RemoveFilter @filter = NULL;
	IF (@filter IS NULL)
		RETURN 0;

	-- set new filter
	EXEC dsp.Log_AddFilter @filter = @filter, @isExclude = 0;
END;