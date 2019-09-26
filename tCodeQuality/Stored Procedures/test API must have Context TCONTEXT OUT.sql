CREATE PROC [tCodeQuality].[test API must have Context TCONTEXT OUT]
AS
BEGIN

	-- Declearing pattern
	DECLARE @pattern_Context TCONTEXT = dsp.String_RemoveWhitespaces('@context TCONTEXT OUT');

	DECLARE @msg TSTRING;
	DECLARE @procedureName TSTRING;

	-- Getting list all procedures with pagination
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting list all procedures with api schema';
	DECLARE @t TABLE (schemaName TSTRING NULL,
		procedureName TSTRING NULL,
		script TBIGSTRING NULL);
	INSERT INTO @t

	SELECT	PD.schemaName, PD.objectName, dsp.String_RemoveWhitespaces(PD.script)
	FROM	dsp.Metadata_ProceduresDefination() AS PD
	WHERE	PD.schemaName = 'api';

	-- Looking for "@context TCONTEXT OUT" phrase
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Looking for "@context TCONTEXT OUT" phrase';
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	CHARINDEX(@pattern_Context, script) < 1;

	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = '"@context TCONTEXT OUT" phrase was not found in procedure: ' + @procedureName;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;
END;