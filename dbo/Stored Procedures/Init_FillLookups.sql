
CREATE PROC dbo.Init_fillLookups
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @tableName TSTRING;

	-- Init lookup tables in this format

	-- LookupTable
	-- SET @tableName = N'LookupTable';
	-- SELECT * INTO #LookupTable FROM dbo.LookupTable WHERE 1 = 0;
	-- INSERT INTO #LookupTable (lookupKey, lookupName)
	-- VALUES 
	--	(const.Gender_male(), N'Male'),
	--	(const.Gender_female(), N'Female');

	-- EXEC dsp.Table_compareData @destinationTableName = @tableName;

END