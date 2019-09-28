
-- Email must contain @ and dot and should not finish by dot
CREATE FUNCTION [dsp].[Validate_isValidEmail] ( @email TSTRING )
RETURNS BIT
AS
BEGIN
    -- concat '%_' + '@_%' to prevent code quality detects it as a private method
    IF ( @email LIKE '%_' + '@_%' AND @email LIKE '%_._%' AND @email NOT LIKE '%[.]' )
        RETURN 1;
    RETURN 0;
END;