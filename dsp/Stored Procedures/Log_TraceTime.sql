CREATE PROCEDURE [dsp].[Log_traceTime]
	@time AS DATETIME OUT, @tag TSTRING
AS
BEGIN
	SET @time = ISNULL(@time, GETDATE());
	DECLARE @timeDiff INT = DATEDIFF(MILLISECOND, @time, GETDATE());

	DECLARE @msg TSTRING;
	EXEC @msg = dsp.Log_formatMessage2 @procId = @@PROCID, @message = '{0}: {1}', @param0 = @tag, @param1 = @timeDiff, @elipsis = 0;
    RAISERROR(@msg, 0, 1) WITH NOWAIT; -- force to flush the buffer

	SET @time = GETDATE();
END;









