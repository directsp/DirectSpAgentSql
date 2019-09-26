CREATE	FUNCTION [dsp].[Param_IsSetBase] (@value SQL_VARIANT,
	@nullAsNotSet BIT)
RETURNS BIT WITH SCHEMABINDING
AS
BEGIN
	IF (@value IS NULL AND @nullAsNotSet = 1)
		RETURN 0;

	DECLARE @type NVARCHAR(/*NoCodeChecker*/ 20) = CAST(SQL_VARIANT_PROPERTY(@value, 'BaseType') AS NVARCHAR(/*NoCodeChecker*/ 20));

	IF (@type LIKE '%int%' AND CAST(@value AS INT) = -1)
		RETURN 0;

	IF (@type LIKE '%char%' AND (CAST(@value AS NVARCHAR(/*NoCodeChecker*/ 10)) = '<notset>' OR CAST(@value AS NVARCHAR(/*NoCodeChecker*/ 10)) = '<noaccess>'))
		RETURN 0;

	IF (@type LIKE '%date%' AND CAST(@value AS DATETIME) = '1753-01-01')
		RETURN 0;

	IF (@type LIKE '%decimal%' AND CAST(@value AS DECIMAL) = -1)
		RETURN 0;

	IF (@type LIKE '%money%' AND CAST(@value AS MONEY) = -1)
		RETURN 0;

	IF (@type LIKE '%float%' AND CAST(@value AS FLOAT) = -1)
		RETURN 0;

	RETURN 1;
END;