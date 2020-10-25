CREATE PROCEDURE [dspCodeAnalysis].[test Wrong use of private method]
AS
BEGIN
    SET NOCOUNT ON;

	-- Declaring pattern
	DECLARE @schemaName TSTRING;
	DECLARE @scriptName TSTRING;
	DECLARE @script TBIGSTRING;
	DECLARE @className TSTRING;

	-- Get procedures and find className
	DECLARE _cursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR --
	SELECT	SV.schemaName, SV.scriptName, SV.script, --
		SUBSTRING(SV.scriptName, 1, CHARINDEX('_', SV.scriptName) - 1) AS className
	FROM	dspCodeAnalysis.ScriptView AS SV
	WHERE	CHARINDEX('_', SV.scriptName) > 0;

	OPEN _cursor;

	FETCH NEXT FROM _cursor
	INTO @schemaName, @scriptName, @script, @className;

	SET @className = REPLACE(@className, '[', '');
	DECLARE @msg TSTRING;
	
	WHILE (@@fETCH_STATUS = 0)
	BEGIN
		DECLARE @hasWrongClassName BIT = 0;
		SELECT @hasWrongClassName = 1
		FROM	STRING_SPLIT(@script, ' ') AS SS
		WHERE	CHARINDEX('_@', SS.value) > 0 AND	REPLACE(SS.value, '[', '') NOT LIKE '%.' + @className + '_@%';

		EXEC @msg = dsp.Formatter_formatMessage @message = 'objectName: [{0}].[{1}]', @param0 = @schemaName, @param1 = @scriptName;
		IF (@hasWrongClassName = 1) --
			EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;

		-- fetch next record
		FETCH NEXT FROM _cursor
		INTO @schemaName, @scriptName, @script, @className;
	END;

	CLOSE _cursor;
	DEALLOCATE _cursor;


END;