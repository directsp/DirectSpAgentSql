﻿
-- /dsp_suppress:1010
CREATE FUNCTION [dsp].[Convert_toString] (@value SQL_VARIANT)
RETURNS TSTRING
BEGIN
	RETURN CAST(@value AS NVARCHAR(4000));
END;