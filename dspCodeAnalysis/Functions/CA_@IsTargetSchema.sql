CREATE FUNCTION dspCodeAnalysis.CA_@IsTargetSchema(@schema AS TSTRING)
RETURNS BIT
BEGIN
	RETURN IIF(@schema IN ('dbo', 'api', 'dsp', 'dspAuth', 'dspCodeAnalysis'), 1, 0);
END