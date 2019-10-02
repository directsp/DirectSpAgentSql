CREATE PROCEDURE [dsp].Exception_throwJson
	@exception TJSON
AS
BEGIN
	DECLARE @exceptionId INT = JSON_VALUE(@exception, '$.errorId');
	THROW @exceptionId, @exception, 1;
END;