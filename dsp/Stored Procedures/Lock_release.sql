﻿CREATE PROCEDURE [dsp].[Lock_release]
	@lockId TSTRING
	AS
BEGIN
	-- Ignore if no lock obtained
	IF (@lockId IS NULL)
		RETURN 0;

	DECLARE @lockName TSTRING = JSON_VALUE(@lockId, '$.lockName');
	DECLARE @lockOwner TSTRING = JSON_VALUE(@lockId, '$.lockOwner');

	-- Don't release lock for transaction to prevent release on uncommitted lock
	IF (@lockOwner = 'Transaction')
	BEGIN
		SET @lockId = NULL;
		RETURN 0;
	END;

	-- Release the lock
	DECLARE @result INT;
	EXEC @result = sys.sp_releaseapplock @Resource = @lockName, @LockOwner = @lockOwner;

	-- throw error for error result
	IF (@result < 0) --
		EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = N'Release AppLock Error! ResultCode: {0}', @param0 = @result;
	
	SET @lockId = NULL;
END;