CREATE PROCEDURE [tCodeQuality].[test Wrong use of Private class]
AS
BEGIN
    SET NOCOUNT ON;

	-- Declaring pattern
	DECLARE @schemaName TSTRING;
	DECLARE @objectName TSTRING;
	DECLARE @script TBIGSTRING;
	DECLARE @className TSTRING;

	-- Get procedures and find className
	DECLARE _cursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR --
	SELECT	PD.schemaName, PD.objectName, REPLACE(REPLACE(REPLACE(PD.script, CHAR(10), ''), CHAR(13), ''), CHAR(9), ' '), --
		SUBSTRING(PD.objectName, 1, CHARINDEX('_', PD.objectName) - 1) AS ClassName
	FROM	dsp.Metadata_proceduresDefination() AS PD
	WHERE	PD.objectName NOT LIKE '%test%' AND CHARINDEX('_', PD.objectName) > 0 AND	CHARINDEX('_@', PD.script) > 0 AND	CHARINDEX('_@', PD.objectName) = 0;

	OPEN _cursor;

	FETCH NEXT FROM _cursor
	INTO @schemaName, @objectName, @script, @className;

	SET @className = REPLACE(@className, '[', '');
	DECLARE @msg TSTRING;
	
	WHILE (@@fETCH_STATUS = 0)
	BEGIN
		DECLARE @hasWrongClassName BIT = 0;
		SELECT @hasWrongClassName = 1
		FROM	STRING_SPLIT(@script, ' ') AS SS
		WHERE	CHARINDEX('_@', SS.value) > 0 AND	REPLACE(SS.value, '[', '') NOT LIKE '%.' + @className + '_@%';

		EXEC @msg = dsp.Formatter_formatMessage @message = 'objectName: [{0}].[{1}]', @param0 = @schemaName, @param1 = @objectName;
		IF (@hasWrongClassName = 1) --
			EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;

		-- fetch next record
		FETCH NEXT FROM _cursor
		INTO @schemaName, @objectName, @script, @className;
	END;

	CLOSE _cursor;
	DEALLOCATE _cursor;


END;



