CREATE TABLE [dspAuth].[SecurityDescriptor] (
    [securityDescriptorId] BIGINT   IDENTITY (1, 1) NOT NULL,
    [objectTypeId]         SMALLINT NOT NULL,
    [objectId]             BIGINT   NOT NULL,
    CONSTRAINT [PK_SecurityDescriptor] PRIMARY KEY CLUSTERED ([securityDescriptorId] ASC),
    CONSTRAINT [FK_SecurityDescriptor_objectTypeId] FOREIGN KEY ([objectTypeId]) REFERENCES [dspAuth].[ObjectType] ([objectTypeId])
);


GO
ALTER TABLE [dspAuth].[SecurityDescriptor] NOCHECK CONSTRAINT [FK_SecurityDescriptor_objectTypeId];




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_objectTypeId]
    ON [dspAuth].[SecurityDescriptor]([objectTypeId] ASC, [objectId] ASC);

