CREATE PROCEDURE [tCodeQuality].[test None of tests should have RETURN phrase]
AS
BEGIN

	-- find first tests with [RET URN] phrase 
	DECLARE @objectName TSTRING;
	
	SELECT	@objectName = S.name + '.' + O.name
	FROM	sys.objects AS O
			INNER JOIN sys.schemas AS S ON S.schema_id = O.schema_id
			INNER JOIN sys.extended_properties AS EP ON EP.major_id = S.schema_id
	WHERE	EP.name = 'tSQLt.TestClass' AND O.name LIKE 'test%' --
		AND CHARINDEX('RETURN', OBJECT_DEFINITION(O.object_id)) > 0 --
		AND O.name <> 'test None of tests should have RETURN phrase';

	DECLARE @errorMessage TSTRING = @objectName + ' has [RETURN] phrase';

	IF (@objectName IS NOT NULL) --
		EXEC dsp.Exception_ThrowGeneral @procId = @@PROCID, @message = @errorMessage;



END;