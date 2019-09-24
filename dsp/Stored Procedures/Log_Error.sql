CREATE PROCEDURE [dsp].[Log_Error]
    @procId AS INT,
    @message AS TSTRING,
    @param0 AS TSTRING = '<notset>',
    @param1 AS TSTRING = '<notset>',
    @param2 AS TSTRING = '<notset>'
AS
BEGIN
    SET @message = 'Error: ' + @message;
    EXEC dsp.Log_Trace @procId = @procId, @message = @message, @param0 = @param0, @param1 = @param1, @param2 = @param2, @elipse = 0
END;