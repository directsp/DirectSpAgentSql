
-- Email must contain @ and dot and should not finish by dot
CREATE FUNCTION [dsp].[Validate_IsValidEmail] ( @email TSTRING )
RETURNS BIT
AS
BEGIN
    DECLARE @pattern TSTRING;
    IF ( @email LIKE '%_@_%' AND @email LIKE '%_._%' AND @email NOT LIKE '%[.]' )
        RETURN 1;
    RETURN 0;
END;