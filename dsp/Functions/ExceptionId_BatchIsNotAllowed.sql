﻿
CREATE FUNCTION [dsp].ExceptionId_BatchIsNotAllowed ()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55023;
END