﻿
CREATE FUNCTION [dsp].ExceptionId_NotImplemented()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55018;
END