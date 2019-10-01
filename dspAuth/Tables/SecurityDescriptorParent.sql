CREATE TABLE [dspAuth].[SecurityDescriptorParent] (
    [securityDescriptorId]       BIGINT NOT NULL,
    [parentSecurityDescriptorId] BIGINT NOT NULL,
    CONSTRAINT [PK_SecurityDescriptorParernt] PRIMARY KEY CLUSTERED ([securityDescriptorId] ASC, [parentSecurityDescriptorId] ASC),
    CONSTRAINT [FK_SecurityDescriptorParernt_parentSecurityDescriptorId] FOREIGN KEY ([parentSecurityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId]),
    CONSTRAINT [FK_SecurityDescriptorParernt_securityDescriptorId] FOREIGN KEY ([securityDescriptorId]) REFERENCES [dspAuth].[SecurityDescriptor] ([securityDescriptorId])
);


GO
CREATE NONCLUSTERED INDEX [IX_securityDescriptorId]
    ON [dspAuth].[SecurityDescriptorParent]([securityDescriptorId] ASC)
    INCLUDE([parentSecurityDescriptorId]);

