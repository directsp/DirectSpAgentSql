CREATE FUNCTION [dsp].[Exception_InvalidArgumentName] (
	@errorMessage TSTRING
)
RETURNS TSTRING
AS
BEGIN
	RETURN JSON_VALUE(JSON_VALUE(@errorMessage, '$.errorMessage'), '$.argumentName');
END;