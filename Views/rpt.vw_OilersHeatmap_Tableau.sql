SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [rpt].[vw_OilersHeatmap_Tableau]
AS

SELECT 
fi.SoldDateTime,
fi.PostedSeatValue,
fi.SeatStatus,
fi.IsAvailable,
fi.IsSaleable,
fi.IsSold,
fi.IsHeld,
fi.IsComp,
fi.IsAttended,
TotalRevenue,
TicketRevenue,
PcTicketValue,
FullPrice,
PurchasePrice,
SoldOrderNum,
EventCode,
EventName,
de.EventDateTime,
SeasonName,
PlanCode,
PlanName,
ItemCode,
ItemName,
ItemDesc,
PriceCode,
PriceCodeDesc,
Price,
TicketType,
TicketTypeDesc,
TicketTypeCategory,
SectionName,
SectionDesc, 
SeatCenter_X x,
SeatCenter_Y y,
dse.rowname,
dse.seat,
IsResold,
ResoldPurchasePrice,
ResoldTotalAmount,
AccountRep,
FirstName + ' ' + LastName AS CustomerName
FROM [dbo].[FactInventory] fi 
JOIN dimevent de ON de.DimEventId = fi.DimEventId
JOIN dimseason ds ON ds.dimseasonid = fi.dimseasonid
JOIN dimplan dp ON dp.dimplanid = fi.solddimplanid
JOIN dimitem di ON di.dimitemid = fi.solddimitemid
JOIN dimpricecode dpc ON dpc.dimpricecodeid = fi.SoldDimPriceCodeId
JOIN dimseat dse ON dse.DimSeatId = fi.DimSeatId
JOIN dimcustomer dc ON dc.dimcustomerid = fi.solddimcustomerid
LEFT JOIN [Oilers].[dbo].[HeatMap_SeatCoordinates] vsc 
	ON vsc.row = dse.RowName --RIGHT('000000000' + dse.rowname, 10) 
	AND vsc.seat = dse.Seat 
	AND vsc.Section = dse.SectionName
WHERE ds.seasonyear =2016





GO
