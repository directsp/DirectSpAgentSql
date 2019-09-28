CREATE PROC [tCodeQuality].[test API must have Context TCONTEXT OUT]
AS
BEGIN

	-- Declearing pattern
	DECLARE @pattern_context TCONTEXT = dsp.String_removeWhitespaces('@context TCONTEXT OUT');

	DECLARE @msg TSTRING;
	DECLARE @procedureName TSTRING;

	-- Getting list all procedures with pagination
	DECLARE @t TABLE (schemaName TSTRING NULL,
		procedureName TSTRING NULL,
		script TBIGSTRING NULL);
	INSERT INTO @t

	SELECT	PD.schemaName, PD.objectName, dsp.String_removeWhitespaces(PD.script)
	FROM	dsp.Metadata_proceduresDefination() AS PD
	WHERE	PD.schemaName = 'api';

	-- Looking for "@context TCONTEXT OUT" phrase
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	CHARINDEX(@pattern_context, script) < 1;

	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = '"@context TCONTEXT OUT" phrase was not found in procedure: ' + @procedureName;
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
	END;
END;