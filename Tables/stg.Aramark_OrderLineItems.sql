CREATE TABLE [stg].[Aramark_OrderLineItems]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Aramark_O__ETL_C__381CA9CD] DEFAULT (getdate()),
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SiteID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemPOSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revenueCenterID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revenueCenterPOSRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[guestcheckId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[guestCheckLineItemID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[businessDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transdatetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[detailType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[recordPosRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[recordName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priceLevel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[voidflag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[genflag1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lineCount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lineTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reportLineCount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reportLineTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[referenceInfo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[referenceInfo2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[doNotShow] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[masterPosRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[daypartid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reasoncodeposRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reasonName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[majorgroupPosRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[majorgroupname] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[familygroupPosRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[familygroupname] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax1total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax2total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax3total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax4total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax5total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax6total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax7total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax8total] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dscMenuItemPosRef] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revenueCenterName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uwsid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
