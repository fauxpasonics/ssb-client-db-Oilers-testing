CREATE TABLE [segmentation].[SegmentationFlatDataefc613ec-783e-4140-9f3e-b0e916c3a5cb]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDataefc613ec-783e-4140-9f3e-b0e916c3a5cb] ADD CONSTRAINT [pk_SegmentationFlatDataefc613ec-783e-4140-9f3e-b0e916c3a5cb] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDataefc613ec-783e-4140-9f3e-b0e916c3a5cb] ON [segmentation].[SegmentationFlatDataefc613ec-783e-4140-9f3e-b0e916c3a5cb] ([_rn])
GO
