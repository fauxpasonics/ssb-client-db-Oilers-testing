CREATE TABLE [mdm].[tmp_MDM_STH]
(
[dimcustomerid] [int] NOT NULL,
[LP] [int] NULL,
[STH] [int] NULL,
[PP] [int] NULL,
[GRP] [int] NULL,
[Concert] [int] NULL,
[CRM_ActivityDate] [datetime] NULL,
[MaxSeatCount] [int] NULL,
[maxPurchaseDate] [datetime] NULL,
[accountid] [int] NULL
)
GO
CREATE CLUSTERED INDEX [ix_MDM_STH] ON [mdm].[tmp_MDM_STH] ([dimcustomerid])
GO
