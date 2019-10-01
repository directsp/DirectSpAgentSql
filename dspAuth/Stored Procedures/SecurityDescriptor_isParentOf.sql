CREATE PROC [dspAuth].[SecurityDescriptor_isParentOf]
	@securityDescriptorId BIGINT, @childSecurityDescriptorId BIGINT, @isParentOf BIT OUT
AS
BEGIN
	SET @isParentOf = 0;

	-- SecurityDescriptor_parents Gets parernts of the SecurityDescriptor including itself
	SELECT	@isParentOf = 1
	FROM	dspAuth.SecurityDescriptor_parents(@childSecurityDescriptorId) AS SOPG
	WHERE	SOPG.securityDescriptorId = @securityDescriptorId;
END;