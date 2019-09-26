CREATE PROCEDURE [dsp].[System_Api]
    @api TJSON = NULL OUT
WITH EXECUTE AS OWNER
AS
BEGIN
    EXEC dsp.Metadata_StoreProcedures @api = @api OUTPUT;
END;