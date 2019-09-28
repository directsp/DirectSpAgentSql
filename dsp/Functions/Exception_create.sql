CREATE	FUNCTION [dsp].[Exception_create] (@procId INT,
	@exceptionId  INT,
	@message TSTRING = NULL)
RETURNS TJSON
AS
BEGIN
	RETURN	dsp.[Exception_createParam4](@procId, @exceptionId , @message, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
END;