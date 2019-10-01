CREATE FUNCTION [dspAuth].[SecurityDescriptor_parents] (@securityDescriptorId BIGINT)
RETURNS TABLE
AS
RETURN (WITH SecurityDescriptorParents
			AS (SELECT	SOI.parentSecurityDescriptorId AS securityDescriptorId
				FROM	dspAuth.SecurityDescriptorParent AS SOI
				WHERE	SOI.securityDescriptorId = @securityDescriptorId
				UNION ALL
				SELECT	SOI.parentSecurityDescriptorId AS securityDescriptorId
				FROM	dspAuth.SecurityDescriptorParent AS SOI
						INNER JOIN SecurityDescriptorParents AS PSO ON PSO.securityDescriptorId = SOI.securityDescriptorId)
		SELECT	SOP.securityDescriptorId
		FROM	SecurityDescriptorParents AS SOP
		UNION
		SELECT	@securityDescriptorId);