CREATE TABLE [stg].[Aramark_OrderHeaders]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Aramark_O__ETL_C__429A3840] DEFAULT (getdate()),
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SiteID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemPOSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[locationID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revenueCenterID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revenueCenterPOSRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[guestcheckId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[orderTypePOSRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[checkNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[openBusinessDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[closeBusinessDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[openDatetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[closeDatetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[numGuests] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[checkRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[checkTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[taxTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[taxExempt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[voidTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tipTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[managerVoidTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[returnTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[errorCorrectTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[xferStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[xferToCheckNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[serviceChargeTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[discountTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax1total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax2total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax3total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax4total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax5total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax6total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax7total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax8total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revenueCenterName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[Aramark_OrderHeaders] ADD CONSTRAINT [PK__Aramark___7EF6BFCD978933AD] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
