
CREATE PROC dbo.Init_FillExceptions
AS
BEGIN
    SET NOCOUNT ON;

	-- delclare your application exceptions here. NOTE: ExceptionId must be started from 56000
	INSERT	dsp.Exception (ExceptionId, ExceptionName, Description)
	VALUES (56001, N'Error1', N'Error1 description'),
		(56002, N'Error2', N'Error2 description');

END