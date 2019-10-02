CREATE TABLE [dspAuth].[SecurityDescriptorParent] (
    [securityDescriptorId]       BIGINT NOT NULL,
    [parentSecurityDescriptorId] BIGINT NOT NULL,
    CONSTRAINT [PK_SecurityDescriptorParernt] PRIMARY KEY CLUSTERED ([securityDescriptorId] ASC, [parentSecurityDescriptorId] ASC),
    CONSTRAINT [FK_SecurityDescriptorParent_parentSecurityDescriptorId] FOREIGN KEY ([parentSecurityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId]),
    CONSTRAINT [FK_SecurityDescriptorParent_securityDescriptorId] FOREIGN KEY ([securityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId])
);


GO
ALTER TABLE [dspAuth].[SecurityDescriptorParent] NOCHECK CONSTRAINT [FK_SecurityDescriptorParent_parentSecurityDescriptorId];


GO
ALTER TABLE [dspAuth].[SecurityDescriptorParent] NOCHECK CONSTRAINT [FK_SecurityDescriptorParent_securityDescriptorId];




GO



GO





GO
CREATE NONCLUSTERED INDEX [IX_securityDescriptorId]
    ON [dspAuth].[SecurityDescriptorParent]([securityDescriptorId] ASC)
    INCLUDE([parentSecurityDescriptorId]);

