CREATE	FUNCTION [dsp].[Exception_BuildMessage] (@procId INT,
	@exceptionId  INT,
	@message TSTRING = NULL)
RETURNS TJSON
AS
BEGIN
	RETURN	dsp.Exception_BuildMessageParam4(@procId, @exceptionId , @message, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
END;
