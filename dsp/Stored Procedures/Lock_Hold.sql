CREATE	PROCEDURE [dsp].[Lock_Hold]
	@objectTypeName TSTRING, @objectName TSTRING = NULL, @isTransactionMode BIT = NULL, @isLockHold BIT = NULL OUT
AS
BEGIN
	SET @objectName = ISNULL(@objectName, '');
	SET @isTransactionMode = ISNULL(@isTransactionMode, 0);
	DECLARE @lockName TSTRING = @objectTypeName + @objectName;
	DECLARE @lockOwner TSTRING = IIF(@isTransactionMode = 1, 'Transaction', 'Session');

	-- Check that Session in Lock
	SET @isLockHold = IIF(APPLOCK_TEST('public', @lockName, 'Exclusive', @lockOwner) = 1, 0, 1);
END;