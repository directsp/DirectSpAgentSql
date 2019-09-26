CREATE	PROC [dsp].[Init_$Start]
	@isProductionEnvironment BIT = NULL, @isWithCleanup BIT = NULL, @reserved BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET @reserved = ISNULL(@reserved, 1);

	----------------
	-- Check Production Environment and Run Cleanup
	----------------
	EXEC dsp.[Init_$InitSettings];
	EXEC dsp.[Init_$Cleanup] @isProductionEnvironment = @isProductionEnvironment OUT, @isWithCleanup = @isWithCleanup OUT;
	EXEC dsp.[Init_$InitSettings];

	----------------
	-- Recreate Strings
	----------------
	IF (@reserved = 1) EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'Recreating strings';
	DELETE	dsp.StringTable WHERE 1=1;
	EXEC dbo.Init_FillStrings;
	EXEC dsp.[Init_$RecreateStringFunctions];

	----------------
	-- Recreate Exceptions 
	----------------
	IF (@reserved = 1) EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'Recreating exception';
	DELETE	dsp.Exception WHERE 1=1;
	EXEC dbo.Init_FillExceptions;

	-- make sure there is no invalid Exception Id for general application
	IF (EXISTS (SELECT		1
												FROM	dsp.Exception AS E
												WHERE	E.[exceptionId] < 56000))
		EXEC dsp.Exception_Throw @procId = @@PROCID, @exceptionId = 55001, @message = 'Application exceptionId cannot be less than 56000!';

	EXEC dsp.[Init_$CreateCommonExceptions];

	----------------
	-- Lookups
	----------------
	IF (@reserved = 1) --
		EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'Filling lookups';
	EXEC dbo.Init_FillLookups;

	IF (@reserved = 1) EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'Filling data';
	EXEC dbo.Init_FillData;

	-- Call Init again to make sure it can be called without cleanup
	IF (@isProductionEnvironment = 0 AND @isWithCleanup = 1 AND @reserved = 1)
	BEGIN
		EXEC dsp.[Init_$Start] @isProductionEnvironment = 0, @isWithCleanup = 0, @reserved = 0;
		RETURN 0;
	END;


	-- Configure large fields
	EXEC dsp.Table_UpdateToUseBlobForFields;

	-- Report it is done
	EXEC dsp.Log_Trace @procId = @@PROCID, @message = 'Init has been completed.';

END;

















