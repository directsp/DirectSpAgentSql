﻿CREATE PROCEDURE [dsp].Exception_ThrowJson
	@exception TJSON
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @exceptionId INT = JSON_VALUE(@exception, '$.errorId');
	THROW @exceptionId, @exception, 1;
END;