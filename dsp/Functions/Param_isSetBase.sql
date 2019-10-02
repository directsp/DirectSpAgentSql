CREATE	FUNCTION [dsp].[Param_isSetBase] (@value SQL_VARIANT,
	@nullAsNotSet BIT)
RETURNS BIT WITH SCHEMABINDING
AS
BEGIN
	IF (@value IS NULL AND @nullAsNotSet = 1)
		RETURN 0;

	DECLARE @type NVARCHAR(/*NoCodeChecker*/ 20) = CAST(SQL_VARIANT_PROPERTY(@value, N'BaseType') AS NVARCHAR(/*NoCodeChecker*/ 20));

	IF (@type LIKE N'%int%' AND CAST(@value AS INT) = -1)
		RETURN 0;

	IF (@type LIKE N'%char%' AND (CAST(@value AS NVARCHAR(/*NoCodeChecker*/ 10)) = N'<notset>' OR CAST(@value AS NVARCHAR(/*NoCodeChecker*/ 10)) = N'<noaccess>'))
		RETURN 0;

	IF (@type LIKE N'%date%' AND CAST(@value AS DATETIME) = N'1753-01-01')
		RETURN 0;

	IF (@type LIKE N'%decimal%' AND CAST(@value AS DECIMAL) = -1)
		RETURN 0;

	IF (@type LIKE N'%money%' AND CAST(@value AS MONEY) = -1)
		RETURN 0;

	IF (@type LIKE N'%float%' AND CAST(@value AS FLOAT) = -1)
		RETURN 0;

	RETURN 1;
END;