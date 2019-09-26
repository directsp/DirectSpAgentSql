CREATE PROCEDURE [tCodeQuality].[test Declare generic types INT, TSTRING]
AS
BEGIN
	DECLARE @msg TSTRING;
	DECLARE @procedureName TSTRING;

	-- Getting list all procedures with pagination
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Getting list all procedures with api schema';
	DECLARE @t TABLE (schemaName TSTRING,
		procedureName TSTRING,
		script TBIGSTRING);
	INSERT INTO @t
	SELECT	PD.schemaName, PD.objectName, PD.script
	FROM	dsp.Metadata_ProceduresDefination() AS PD
	WHERE	PD.objectName NOT IN ('Convert_ToString', 'Convert_ToSqlvariant', 'CRYPT_PBKDF2_VARBINARY_SHA512');

	-- Looking for "tinyint and smallint" phrase
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Looking for "tinyint and smallint" phrase';
	SET @procedureName = NULL;
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	(schemaName IN ( 'dbo', 'api', 'dsp' )) AND (CHARINDEX('tinyint', script) > 0 OR	CHARINDEX('smallint', script) > 0);
	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = 'Code should not contains SMALLINT or TINYINT in procedure: ' + @procedureName;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;

	-- Looking for "NVARCHAR(MAX)" phrase
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = N'Looking for "NVARCHAR(MAX)" phrase';
	SET @procedureName = NULL;
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	(schemaName IN ( 'dbo', 'api', 'dsp' )) AND (script LIKE '%VARCHAR([0-9]%' OR script LIKE '%VARCHAR(MAX)%');

	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = 'Code should not contains NVARCHAR(XX) in procedure: ' + @procedureName;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;

END;