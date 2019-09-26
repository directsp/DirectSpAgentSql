CREATE PROCEDURE [tCodeQuality].[test const Functions must have WITH SCHEMABINDING]
AS
BEGIN

	-- Declaring pattern
	DECLARE @pattern_Context TCONTEXT = dsp.String_RemoveWhitespaces('WITH SCHEMABINDING');

	DECLARE @msg TSTRING;
	DECLARE @functionName TSTRING;

	-- Getting list all procedures with pagination
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting list all functions with const schema';
	DECLARE @t TABLE (schemaName TSTRING NULL,
		FunctionName TSTRING NULL,
		script TBIGSTRING NULL);
	INSERT INTO @t
	SELECT	PD.schemaName, PD.objectName, dsp.String_RemoveWhitespaces(PD.script)
	FROM	dsp.Metadata_ProceduresDefination() AS PD
	WHERE	PD.schemaName = 'const';

	-- Looking for "@context TCONTEXT OUT" phrase
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Looking for "WITH SCHEMABINDING" phrase';
	SELECT	@functionName = schemaName + '.' + FunctionName
	FROM	@t
	WHERE	CHARINDEX(@pattern_Context, script) < 1 AND CHARINDEX('TSTRING', script) = 0;

	IF (@functionName IS NOT NULL)
	BEGIN
		SET @msg = '"WITH SCHEMABINDING" phrase was not found in Function: ' + @functionName;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;
END;