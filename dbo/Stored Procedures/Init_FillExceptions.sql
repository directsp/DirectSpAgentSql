﻿
CREATE PROC dbo.Init_fillExceptions
AS
BEGIN
    SET NOCOUNT ON;

	-- delclare your application exceptions here. NOTE: exceptionId must be started from 56000
	INSERT	dsp.Exception ([exceptionId], [exceptionName], [description])
	VALUES (56001, N'Error1', N'Error1 description'),
		(56002, N'Error2', N'Error2 description');

END