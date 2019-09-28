CREATE PROCEDURE [dsp].[Log_filter]
	@filter TSTRING = NULL
AS
BEGIN
	SET @filter = NULLIF(@filter, '');

	-- remove all old filters
	EXEC dsp.Log_removeFilter @filter = NULL;
	IF (@filter IS NULL)
		RETURN 0;

	-- set new filter
	EXEC dsp.Log_addFilter @filter = @filter, @isExclude = 0;
END;