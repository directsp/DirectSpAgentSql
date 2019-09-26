CREATE PROCEDURE [tCodeQuality].[test dbo should not have WITH EXECUTE AS OWNER]
AS
BEGIN
	-- Declaring pattern
	DECLARE @pattern_WithExecuteASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXECUTE AS OWNER');
	DECLARE @pattern_WithExecASOwner TSTRING = dsp.String_RemoveWhitespaces('WITH EXEC AS OWNER');
	DECLARE @msg TSTRING;
	DECLARE @procedureName TSTRING;

	-- Getting list all procedures with pagination
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting list all procedures with pagination';
	DECLARE @t TABLE (schemaName TSTRING NULL,
		procedureName TSTRING NULL,
		script TBIGSTRING NULL);

	INSERT INTO @t
	SELECT	PD.schemaName, PD.objectName, PD.script
	FROM	dsp.Metadata_ProceduresDefination() AS PD
	WHERE	PD.schemaName IN ( 'dbo', 'dsp', 'perm' );

	-- Looking for "With Execute AS owner" phrase
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Looking for "With Execute AS owner" phrase';
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	CHARINDEX(@pattern_WithExecuteASOwner, script) > 0 OR	CHARINDEX(@pattern_WithExecASOwner, script) > 0;

	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = '"With Execute AS owner" phrase was found in procedure: ' + @procedureName;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;
END;