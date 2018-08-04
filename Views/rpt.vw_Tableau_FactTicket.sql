SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [rpt].[vw_Tableau_FactTicket]
as
SELECT fts.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, dtt.TicketTypeName, 
dpt.PlanTypeName, 
dstt.SeatTypeName, 
fts.IsComp,
fts.DimTicketTypeId, 
fts.DimPlanTypeId, 
fts.DimSeatTypeId, 
fts.TicketType,
dpc.PriceCode, 
fts.RetailTicketType, 
fts.RetailQualifiers,
SUM(fts.QtySeat ) Qty, 
SUM(fts.TotalRevenue) Rev,
EventDateRank
FROM dbo.FactTicketSales fts
INNER JOIN 
(
SELECT de.DimSeasonId, de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
		, ROW_NUMBER() OVER(ORDER BY de.EventDate) EventDateRank		
		FROM rpt.vw_DimEvent de
		INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
		WHERE DimSeasonId = 37		
) e ON e.DimEventId = fts.DimEventId
LEFT OUTER JOIN dbo.DimTicketType dtt ON dtt.DimTicketTypeId = fts.DimTicketTypeId
LEFT OUTER JOIN dbo.DimPlanType dpt ON dpt.DimPlanTypeId = fts.DimPlanTypeId
LEFT OUTER JOIN dbo.DimSeatType dstt ON dstt.DimSeatTypeId = fts.DimSeatTypeId
LEFT OUTER JOIN dbo.DimPriceCode dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
GROUP by e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, fts.DimEventId, dtt.TicketTypeName, fts.TicketType, dpc.PriceCode, dpt.PlanTypeName, dstt.SeatTypeName, fts.IsComp
, fts.RetailTicketType, fts.RetailQualifiers ,fts.DimTicketTypeId, fts.DimPlanTypeId, fts.DimSeatTypeId, EventDateRank
GO
