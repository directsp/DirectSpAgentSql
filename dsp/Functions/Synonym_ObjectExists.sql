CREATE FUNCTION [dsp].[Synonym_objectExists](@schemaName TSTRING, @synonymName TSTRING)
RETURNS BIT
BEGIN
	RETURN IIF ( exists (select 1 from sys.synonyms where name = @synonymName  AND schema_id= SCHEMA_ID(@schemaName) AND base_object_name NOT LIKE  '%NullServer%'), 1 , 0);
end