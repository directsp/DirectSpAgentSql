﻿
CREATE FUNCTION [dsp].ExceptionId_UserIsDisabled()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55019;
END