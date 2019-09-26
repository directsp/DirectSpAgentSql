CREATE PROC [dsp].[Job_Delete]
	@jobNamePattern TSTRING
AS
BEGIN
	DECLARE _cursor CURSOR FAST_FORWARD FORWARD_ONLY FORWARD_ONLY LOCAL FOR
	SELECT	S.name AS jobName
	FROM msdb.dbo.sysjobs AS S
	WHERE	S.name LIKE @jobNamePattern;

	OPEN _cursor;

	DECLARE @jobName TSTRING;
	FETCH NEXT FROM _cursor
	INTO @jobName;

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		BEGIN TRY
			EXEC msdb.dbo.sp_delete_job @job_name = @jobName;
		END TRY
		BEGIN CATCH
		END CATCH;

		FETCH NEXT FROM _cursor
		INTO @jobName;
	END;
	CLOSE _cursor
	DEALLOCATE _cursor
END;