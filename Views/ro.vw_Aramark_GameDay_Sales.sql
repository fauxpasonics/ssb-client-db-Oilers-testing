SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ro].[vw_Aramark_GameDay_Sales]
AS



SELECT 
e.DimEventId
,e.EventCode
,e.EventName
,o.revenueCenterID
,o.revenueCenterPOSRef
,o.revenueCenterName
,o.uwsid
,o.guestcheckId
,o.guestCheckLineItemID
,CAST(o.businessDate AS DATE) AS BusinessDate
,CAST(o.transdatetime AS DATETIME) AS TransDatetime
,o.detailType
,o.recordPosRef
,o.recordName
,o.priceLevel
,o.voidflag
,o.genflag1
,o.lineCount
,CASE WHEN o.detailType = '1' THEN CAST(o.lineTotal AS VARCHAR(50))  ELSE '' END AS ItemTotal
,CASE WHEN o.detailType = '3' THEN CAST(o.lineTotal AS VARCHAR(50))  ELSE '' END AS TotalTip
,o.tax1total AS ItemTax
,o.reportLineCount
,o.reportLineTotal
,o.referenceInfo
,o.majorgroupname
,o.familygroupname


FROM [ods].[Aramark_OrderLineItems] o
LEFT JOIN dbo.DimEvent_V2 e
ON e.EventDate = CAST(o.businessDate AS DATE)
WHERE  o.detailType IN ('1','3')
--detail 1 is saleable line items
--2 is manager comps and OEG Bucks
--3 is charged tip and tips are on line item
--4 is your cash, debit, mastercard, visa transaction lineitems

--ask if they want to see voids in view





UNION


SELECT 
e.DimEventId
,e.EventCode
,e.EventName
,o.revenueCenterID
,o.revenueCenterPOSRef
,o.revenueCenterName
,o.uwsid
,o.guestcheckId
,o.guestCheckLineItemID
,CAST(o.businessDate AS DATE) AS BusinessDate
,CAST(o.transdatetime AS DATETIME) AS TransDatetime
,o.detailType
,o.recordPosRef
,o.recordName
,o.priceLevel
,o.voidflag
,o.genflag1
,o.lineCount
,null AS lineTotal --tax exclusive
, o.lineTotal AS tip
,o.tax1total
,o.reportLineCount
,o.reportLineTotal
,o.referenceInfo
,o.majorgroupname
,o.familygroupname


FROM [ods].[Aramark_OrderLineItems] o
JOIN dbo.DimEvent_V2 e
ON e.EventDate = CAST(o.businessDate AS DATE)
WHERE o.detailType = '3'









GO
