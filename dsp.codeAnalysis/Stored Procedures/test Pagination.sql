/*
	One of the following phrase must exits 
	1) @recordIndex = @recordIndex (Means the procedure is a wrapper)
	OR 
	1) EXEC dbo.Validate_recordCount @recordCount = @recordCount OUT
	2) OFFSET @recordIndex ROWS FETCH NEXT @recordCount ROWS ONLY
*/
CREATE PROCEDURE dspCodeAnalysis.[test Pagination]
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaring pattern
    DECLARE @pattern_offset TSTRING = LOWER(dspCodeAnalysis.Test_@removeWhitespaces('OFFSET @recordIndex ROWS FETCH NEXT @recordCount ROWS ONLY'));
    DECLARE @pattern_pageIndex TSTRING = LOWER(dspCodeAnalysis.Test_@removeWhitespaces('@recordIndex = @recordIndex'));
    DECLARE @msg TSTRING;
    DECLARE @procedureName TSTRING;

    -- Checking implementation paging in api and dbo StoreProcedure
    SELECT  @procedureName = SV.fullName
      FROM  dspCodeAnalysis.ScriptView AS SV
     WHERE  (   CHARINDEX('/dsp_suppress:1011.', SV.scriptNoSpace)=0 
				AND CHARINDEX('@recordindex', SV.scriptNoSpace) > 0 --
                AND CHARINDEX('@recordcount', SV.scriptNoSpace) > 0 --
                AND CHARINDEX(@pattern_pageIndex, SV.scriptNoSpace) > 0 --  Wrapper Phrase: (@recordIndex = @recordIndex) 
                AND CHARINDEX(@pattern_offset, SV.scriptNoSpace) = 0); --ValidatePage size must exists if it not wrapper

    IF (@procedureName IS NOT NULL)
    BEGIN
        SET @msg = 'Pagination is not implemented properly in procedure: ' + @procedureName;
        EXEC dsp.Exception_throwGeneral @procId = @@PROCID, @message = @msg;
    END;
END;