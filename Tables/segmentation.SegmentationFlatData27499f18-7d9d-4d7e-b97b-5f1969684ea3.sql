CREATE TABLE [segmentation].[SegmentationFlatData27499f18-7d9d-4d7e-b97b-5f1969684ea3]
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
ALTER TABLE [segmentation].[SegmentationFlatData27499f18-7d9d-4d7e-b97b-5f1969684ea3] ADD CONSTRAINT [pk_SegmentationFlatData27499f18-7d9d-4d7e-b97b-5f1969684ea3] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData27499f18-7d9d-4d7e-b97b-5f1969684ea3] ON [segmentation].[SegmentationFlatData27499f18-7d9d-4d7e-b97b-5f1969684ea3] ([_rn])
GO
