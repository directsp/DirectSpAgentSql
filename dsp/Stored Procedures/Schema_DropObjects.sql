-- @ObjectType Can be 'FN' or 'P'
CREATE PROC [dsp].[Schema_DropObjects]
	@schemaName TSTRING, @dropFunctions BIT = 0, @dropProcedures BIT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET @dropFunctions = ISNULL(@dropFunctions, 0);
	SET @dropProcedures = ISNULL(@dropProcedures, 0);

	DECLARE @objectName TSTRING;
	DECLARE @objectType TSTRING;
	DECLARE @ddlText TSTRING;

	--Drop String Functions
	DECLARE _cursor CURSOR LOCAL FAST_FORWARD READ_ONLY FOR
	SELECT	O.name, O.type
	FROM	sys.objects AS O
			INNER JOIN sys.schemas AS S ON S.schema_id = O.schema_id
	WHERE	S.name = @schemaName
			AND O.type IN ( 'FN', 'P', 'IF', 'TF' );

	OPEN _cursor;
	FETCH NEXT FROM _cursor
	INTO @objectName, @objectType;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@dropFunctions = 1 AND @objectType IN ('FN', 'IF', 'TF'))
		BEGIN
			SET @ddlText = 'DROP FUNCTION ' + @schemaName + '.' + @objectName;
			EXEC sys.sp_executesql @stmt = @ddlText;
		END;

		IF (@dropProcedures = 1 AND @objectType = 'P')
		BEGIN
			SET @ddlText = 'DROP PROCEDURE ' + @schemaName + '.' + @objectName;
			EXEC sys.sp_executesql @stmt = @ddlText;
		END;

		FETCH NEXT FROM _cursor
		INTO @objectName, @objectType;
	END;
	CLOSE _cursor;
	DEALLOCATE _cursor;

END;