CREATE FUNCTION [dsp].[Exception_invalidArgumentName] (
	@errorMessage TSTRING
)
RETURNS TSTRING
AS
BEGIN
	RETURN JSON_VALUE(JSON_VALUE(@errorMessage, '$.errorMessage'), '$.argumentName');
END;