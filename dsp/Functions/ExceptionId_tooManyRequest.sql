﻿
CREATE FUNCTION [dsp].ExceptionId_tooManyRequest ()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55024;
END