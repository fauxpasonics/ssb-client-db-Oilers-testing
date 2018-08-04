SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ro].[vw_FactticketSales_NEW] AS (

SELECT 
FactTicketSalesId as FactTicketSalesId
,DimDateId as DimDateId
,CAST(NULL AS DATETIME) AS DimDateId_OrigSale --Zach please review
, DimTimeId AS DimTimeId
,DimTicketCustomerId as DimCustomerId
, DimArenaId as DimArenaId
,DimSeasonId as DimSeasonId
,DimItemId as DimItemId
,DimEventId as DimEventId
,DimPlanId as DimPlanId
--, as DimPriceCodeMasterId
, DimPriceCodeId as DimPriceCodeId
,DimSeatId_Start as DimSeatIdStart
,DimLedgerId as DimLedgerId
--, as DimClassTMId
,DimSalesCodeId as DimSalesCodeId
,DimPromoId as DimPromoId
,DimPlanTypeId as DimPlanTypeId
,DimTicketTypeId as DimTicketTypeId
,DimSeatTypeId as DimSeatTypeId
,DimTicketClassId as DimTicketClassId
,cast(NULL as int)  as DimTicketClassId2
,cast(null as int) as DimTicketClassId3
,cast(null as int) as DimTicketClassId4
,cast(null as int) as DimTicketClassId5
--, as DimCustomerIdSalesRep
--, as DimCustomerId_TransSalesRep
,TM_order_num as OrderNum
,TM_order_line_item as OrderLineItem
,TM_order_line_item_seq as OrderLineItemSeq
,QtySeat as QtySeat
,QtySeatFSE as QtySeatFSE
,RevenueTotal as TotalRevenue
,RevenueTicket as TicketRevenue
, cast (null as decimal(18,6)) as PcTicketValue
,FullPrice as FullPrice
--, as BlockDiscountCalc
--, as BlockDiscountArchtics
--, as Discount
--, as BlockSurcharge
--, as Surcharge
, TM_purchase_price as PurchasePrice
, TM_block_purchase_price as BlockFullPrice
, TM_block_purchase_price as BlockPurchasePrice
--, as PcPrice
--, as PcPrintedPrice
,TM_pc_ticket as PcTicket
,TM_pc_tax as PcTax
,TM_pc_licfee as PcLicenseFee
,TM_pc_other1 as PcOther1
,TM_pc_other2 as PcOther2
,PaidAmount as PaidAmount
,OwedAmount as OwedAmount
,PaidStatus as PaidStatus
,IsPremium as IsPremium
,IsDiscount as IsDiscount
,IsComp as IsComp
,IsHost as IsHost
,IsPlan as IsPlan
,IsPartial as IsPartial
,IsSingleEvent as IsSingleEvent
,IsGroup as IsGroup
,IsBroker as IsBroker
,IsRenewal as IsRenewal
,IsExpanded as IsExpanded
,IsAutoRenewalNextSeason as IsAutoRenewalNextSeason
--, as DiscountCode
--, as SurchargeCode
--, as PricingMethod
,TM_comp_code as CompCode
,TM_comp_name as CompName
--, as GroupSalesName
,IsGroup  as GroupFlag -- dupe??
--, as ClassName
,TM_ticket_type as TicketType
,TM_tran_type as TranType
,TM_sales_source_name as SalesSource
,TM_retail_ticket_type as RetailTicketType
,TM_retail_qualifiers as RetailQualifiers
--, as OtherInfo1
--, as OtherInfo2
--, as OtherInfo3
--, as OtherInfo4
--, as OtherInfo5
--, as OtherInfo6
--, as OtherInfo7
--, as OtherInfo8
--, as OtherInfo9
--, as OtherInfo10
--, as TicketSeqId
,CreatedBy as SSCreatedBy
,UpdatedBy as SSUpdatedBy
,CreatedDate as SSCreatedDate
,UpdatedDate as SSUpdatedDate
,ETL__SSID as SSID
,ETL__SSID_TM_event_id as SSID_event_id
,ETL__SSID_TM_section_id as SSID_section_id
,ETL__SSID_TM_row_id as SSID_row_id
,ETL__SSID_TM_seat_num as SSID_seat_num
,ETL__SSID_TM_acct_id as SSID_acct_id
,ETL__SSID_TM_price_code as SSID_price_code
, ETL__SourceSystem as SourceSystem
,ETL__DeltaHashKey as DeltaHashKey
,cast(null as nvarchar(250))as CreatedBy
,cast(null as nvarchar(250)) as UpdatedBy
,ETL__CreatedDate as CreatedDate
,ETL__UpdatedDate as UpdatedDate
,ETL__IsDeleted as IsDeleted
,cast( null as datetime) as DeleteDate
FROM ro.vw_FactTicketSales



)
GO
