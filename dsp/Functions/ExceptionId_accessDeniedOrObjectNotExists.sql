﻿
CREATE FUNCTION [dsp].ExceptionId_accessDeniedOrObjectNotExists()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55002;
END