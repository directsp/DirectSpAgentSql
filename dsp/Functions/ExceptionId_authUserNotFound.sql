﻿
CREATE FUNCTION [dsp].[ExceptionId_authUserNotFound] ()
RETURNS INT WITH SCHEMABINDING
AS
BEGIN
	RETURN 55025;
END