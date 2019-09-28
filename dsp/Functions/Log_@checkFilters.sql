
-- returns 1, should the message be printed
CREATE FUNCTION dsp.Log_@checkFilters ( @message TSTRING )
RETURNS BIT
AS
BEGIN
	-- return 0 if @message likes exclude filters
	IF EXISTS( SELECT 1 FROM dsp.LogFilterSetting AS LFS 
		WHERE LFS.logUserId = SYSTEM_USER AND LFS.[isExludedFilter] = 1 AND @message LIKE '%'+ LFS.[filter] + '%' )
		RETURN 0;

	-- return 1 if include filters are empty
	IF NOT EXISTS( SELECT 1 FROM dsp.LogFilterSetting AS LFS WHERE LFS.logUserId = SYSTEM_USER AND LFS.[isExludedFilter] = 0)
		RETURN 1;
	
	--  return 1 if @message likes include filters  
	IF EXISTS( SELECT 1 FROM dsp.LogFilterSetting AS LFS 
		WHERE LFS.logUserId = SYSTEM_USER AND LFS.[isExludedFilter] = 0 AND @message LIKE '%'+ LFS.[filter] + '%' )
		RETURN 1;

	RETURN 0;
END;