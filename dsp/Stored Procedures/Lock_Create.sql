CREATE PROCEDURE [dsp].[Lock_create]
	@objectTypeName TSTRING, @objectName TSTRING = NULL, @isTransactionMode BIT = 1, @lockId TSTRING = NULL OUT
AS
BEGIN
	SET @lockId = N'{}';
	SET @objectName = ISNULL(@objectName, '');
	SET @isTransactionMode = ISNULL(@isTransactionMode, 1);
	
	DECLARE @lockName TSTRING = @objectTypeName + @objectName;
	DECLARE @lockOwner TSTRING = IIF(@isTransactionMode = 1, 'Transaction', 'Session');

	-- Getting Lock
	DECLARE @result INT;
	EXEC @result = sys.sp_getapplock @Resource = @lockName, @LockMode = 'Exclusive', @LockOwner = @lockOwner;

	-- throw error for error result
	IF (@result < 0) 
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = N'Get AppLock Error! ErrorNumber: {0}', @param0 = @result;

	SET @lockId = JSON_MODIFY(@lockId, '$.lockOwner', @lockOwner);
	SET @lockId = JSON_MODIFY(@lockId, '$.lockName', @lockName);
END;































