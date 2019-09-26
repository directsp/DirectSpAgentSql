CREATE PROC [tCodeQuality].[Private_CompareConstFunctionReturnValueWithScriptValue]
	@script TBIGSTRING OUT, @constFunctionName TSTRING OUT, @constValueInFunction INT OUT, @constValueInScript INT OUT, @isMatch BIT OUT
AS
BEGIN
	DECLARE @startStrCharIndex INT;
	DECLARE @endStrCharIndex INT;
	DECLARE @startNumPadIndex INT;
	DECLARE @endStrNumdIndex INT;

	SET @isMatch = 0;
	SET @constValueInScript = NULL;
	SET @constValueInFunction = NULL;

	-- Getting Function Name
	SET @startStrCharIndex = CHARINDEX('/*co' + 'nst.', @script);
	IF (@startStrCharIndex = 0)
		RETURN 0;

	SET @endStrCharIndex = CHARINDEX('()*/', @script, @startStrCharIndex) + 2;
	SET @startStrCharIndex = @startStrCharIndex + 2;
	SET @constFunctionName = SUBSTRING(@script, @startStrCharIndex, @endStrCharIndex - @startStrCharIndex);
	
	-- Getting Function Value
	BEGIN TRY
		SET @script = SUBSTRING(@script, @endStrCharIndex + 2, LEN(@script));
		SET @startNumPadIndex = PATINDEX('%[0-9]%', @script);
		SET @endStrNumdIndex = PATINDEX('%[^0-9]%', @script);
		SET @constValueInScript = CAST(SUBSTRING(@script, @startNumPadIndex, @endStrNumdIndex - @startNumPadIndex) AS INT);
	END TRY
	BEGIN CATCH
		EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'ConstFunctionValue has written before ConstFunctionName!';
	END CATCH;

	-- Getting Function Id
	BEGIN TRY
		DECLARE @sqlQuery TSTRING = 'SET @id = ' + @constFunctionName;
		EXEC sys.sp_executesql @stmt = @sqlQuery, @params = N'@id INT OUTPUT', @param1 = @constValueInFunction OUTPUT;
		SET @isMatch = IIF(@constValueInFunction = @constValueInScript, 1, 0);
	END TRY
	BEGIN CATCH
	END CATCH;

	DECLARE @startIndex INT = @endStrCharIndex - @startStrCharIndex;
	
	SET @script = SUBSTRING(@script, @startIndex, (LEN(@script)))
END;



