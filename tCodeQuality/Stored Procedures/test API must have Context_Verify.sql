
CREATE PROCEDURE [tCodeQuality].[test API must have Context_Verify]
AS
BEGIN
	DECLARE @msg TSTRING;
	DECLARE @procedureName TSTRING;

	-- Getting list all procedures with pagination
	DECLARE @t TABLE (schemaName TSTRING NULL,
		procedureName TSTRING NULL,
		script TBIGSTRING NULL);

	INSERT INTO @t
	SELECT	VPD.schemaName, VPD.objectName, VPD.script
	FROM	dsp.Metadata_ProceduresDefination() AS VPD
	WHERE	VPD.Type = 'P'

	-- Looking for "Context_Verify" in api procedure
	SELECT	@procedureName = schemaName + '.' + procedureName
	FROM	@t
	WHERE	(schemaName IN ( 'api' )) AND	script NOT LIKE N'%dsp.Context_Verify%';

	IF (@procedureName IS NOT NULL)
	BEGIN
		SET @msg = 'Code should contain dsp.Context_Verify in procedure: ' + @procedureName;
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @msg;
	END;
END;