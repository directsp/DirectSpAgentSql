CREATE PROCEDURE [dsp].[System_api]
    @api TJSON = NULL OUT
WITH EXECUTE AS OWNER
AS
BEGIN
    EXEC dsp.Metadata_storeProcedures @api = @api OUTPUT;
END;