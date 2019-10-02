CREATE PROCEDURE dsp.System_api
    @api TJSON = NULL OUT
AS
BEGIN
    EXEC dsp.Metadata_storeProcedures @api = @api OUTPUT;
END;