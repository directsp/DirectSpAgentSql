/*
	One of the following phrase must exits 
	1) @recordIndex = @recordIndex (Means the procedure is a wrapper)
	OR 
	1) EXEC dbo.Validate_recordCount @recordCount = @recordCount OUT
	2) OFFSET @recordIndex ROWS FETCH NEXT @recordCount ROWS ONLY
*/
CREATE PROCEDURE [tCodeQuality].[test Pagination]
AS
BEGIN
	SET NOCOUNT ON

	-- Declaring pattern
	DECLARE @pattern_offset TSTRING = dsp.String_removeWhitespaces('OFFSET @recordIndex ROWS FETCH NEXT @recordCount ROWS ONLY');
	DECLARE @pattern_pageIndex TSTRING = dsp.String_removeWhitespaces('@recordIndex = @recordIndex');
	DECLARE @msg TSTRING;
	DECLARE @procedureName TSTRING;

	-- Getting list all procedures with pagination
	DECLARE @t TABLE (schemaName TSTRING NULL,
		procedureName TSTRING NULL,
		script TBIGSTRING NULL);

	INSERT INTO @t
	SELECT	PD.schemaName, PD.objectName, PD.script
	FROM	dsp.Metadata_proceduresDefination() AS PD
	WHERE	CHARINDEX('@recordIndex', PD.script) > 0 AND CHARINDEX('@recordCount', PD.script) > 0 AND
			PD.objectName NOT IN ( 'Context_validatePagination', 'Context_verify' );


	-- Checking implementation paging in api and dbo StoreProcedure
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	(	CHARINDEX(@pattern_pageIndex, script) > 0 --  Wrapper Phrase: (@recordIndex = @recordIndex) 
				AND CHARINDEX(@pattern_offset, script) = 0); --ValidatePage size must exists if it not wrapper

	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = 'Paging is not implemented properly in procedure: ' + @procedureName;
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
	END;
END;