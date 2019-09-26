CREATE	FUNCTION [dsp].[Exception_Create] (@procId INT,
	@exceptionId  INT,
	@message TSTRING = NULL)
RETURNS TJSON
AS
BEGIN
	RETURN	dsp.[Exception_CreateParam4](@procId, @exceptionId , @message, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
END;
