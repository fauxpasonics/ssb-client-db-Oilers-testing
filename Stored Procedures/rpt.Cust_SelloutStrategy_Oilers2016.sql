SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--EXEC [rpt].[Cust_Coyotes_SelloutStrategy_Dev] '2015-07-01', '2016-08-01',0

CREATE PROCEDURE [rpt].[Cust_SelloutStrategy_Oilers2016] 
(
	@StartDate DATE = '2015-07-01',
	@EndDate DATE = '2016-06-30',
	@NumGames INT = 10
)

AS

--DECLARE @Startdate DATE = '2015-07-01'
--DECLARE @enddate DATE  = '2016-06-30'
--DECLARE @numgames INT = 10

--IF (@StartDate IS NOT NULL)
--BEGIN SET @NumGames = 0
--end
--BEGIN

--DROP TABLE #ReportOutput
--DROP TABLE #ReportSortOrder
--Drop TABLE #ROload
--DROP TABLE #Events
--DROP TABLE #stgSales
--DROP TABLE #stgSales2
--DROP TABLE #stgSales3
--DROP TABLE #Capacity
--DROP TABLE #Velocity
--DROP TABLE #Snapshot

CREATE TABLE #Events (
	DimSeasonId NVARCHAR(255),
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	EventDate DATE,
	EventTime TIME,
	EventDayOfWeek NVARCHAR(255)
)

CREATE TABLE #ReportOutput (
	DimEventId NVARCHAR(25),
	EventName NVARCHAR(85),
	EventDate DATE,
	EventTime TIME,
	EventDayOfWeek NVARCHAR(85),
	Section1 NVARCHAR(85),
	Section2 NVARCHAR(85),		
	SeatTypeDrill NVARCHAR (85),
	Qty DECIMAL(18,6),	
	Rev DECIMAL(18,6),
	Capacity VARCHAR (20)
)

IF ( ISNULL(@NumGames,0) > 0 )
BEGIN

 /**************** Event temp Table ****************/
 --DROP TABLE #Events
	INSERT INTO #Events (DimSeasonId, DimEventId, EventName, EventDate, EventTime, EventDayOfWeek )
	SELECT a.DimSeasonId, a.DimEventId, a.EventName, a.EventDate, a.EventTime, a.EventDayOfWeek		
	FROM (
		SELECT de.DimSeasonId, de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
		, ROW_NUMBER() OVER(ORDER BY de.EventDate) EventDateRank		
		FROM rpt.vw_DimEvent de
		INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
		WHERE DimSeasonId = 37
		AND de.EventDate > DATEADD(HOUR, (SELECT UTCOffset FROM dbo.DimDate WHERE CalDate = CAST(GETDATE() AS DATE)), GETDATE())
	) a
	WHERE a.EventDateRank <= @NumGames

END
ELSE BEGIN

	INSERT INTO #Events ( DimEventId, EventName, EventDate, EventTime, EventDayOfWeek )
	SELECT de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
	FROM rpt.vw_DimEvent de
	INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
	WHERE DimSeasonId = 37
	AND EventDate BETWEEN @StartDate AND @EndDate

END

--SELECT TOP 10 de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
--INTO #Events
--FROM rpt.vw_DimEvent de
--INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
--WHERE DimSeasonId = 6
----AND EventDate BETWEEN @StartDate AND @EndDate

/**************** Staging sales temp Table #1 ****************/

SELECT fts.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, dtt.TicketTypeName, dpt.PlanTypeName, dstt.SeatTypeName, fts.IsComp
, fts.DimTicketTypeId, fts.DimPlanTypeId, fts.DimSeatTypeId, fts.TicketType, dpc.PriceCode, fts.RetailTicketType, fts.RetailQualifiers ,SUM(fts.QtySeat ) Qty, SUM(fts.TotalRevenue) Rev
INTO  #stgSales
FROM dbo.FactTicketSales fts
INNER JOIN #Events e ON e.DimEventId = fts.DimEventId
LEFT OUTER JOIN dbo.DimTicketType dtt ON dtt.DimTicketTypeId = fts.DimTicketTypeId
LEFT OUTER JOIN dbo.DimPlanType dpt ON dpt.DimPlanTypeId = fts.DimPlanTypeId
LEFT OUTER JOIN dbo.DimSeatType dstt ON dstt.DimSeatTypeId = fts.DimSeatTypeId
LEFT OUTER JOIN dbo.DimPriceCode dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
GROUP by e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, fts.DimEventId, dtt.TicketTypeName, fts.TicketType, dpc.PriceCode, dpt.PlanTypeName, dstt.SeatTypeName, fts.IsComp
, fts.RetailTicketType, fts.RetailQualifiers ,fts.DimTicketTypeId, fts.DimPlanTypeId, fts.DimSeatTypeId
ORDER BY fts.DimEventId, dtt.TicketTypeName
--SELECT * from #stgSales WHERE DimEventId = 36
--DROP TABLE #stgSales

/**************** Staging sales temp Table #2 ****************/
SELECT SaleStatus, DimEventId, a.TicketTypeName, PlanTypeName, SeatTypeName, a.PriceCode, a.IsComp, a.RetailTicketType, a.RetailQualifiers , a.DimTicketTypeId, a.DimPlanTypeId, a.DimSeatTypeId, Qty, Rev
INTO  #stgSales2
FROM (
	SELECT 'Sold' SaleStatus, f.DimEventId
	, dtt.TicketTypeName
	, dpt.PlanTypeName
	, dstt.SeatTypeName
	, dtt.DimTicketTypeId
	, dpt.DimPlanTypeId
	, dstt.DimSeatTypeId
	, f.PriceCode
	, f.IsComp
	, f.RetailTicketType, f.RetailQualifiers
		, SUM(f.Qty) Qty
		, SUM(f.Rev) Rev
	FROM #stgSales f
	INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
	INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
	INNER JOIN dbo.DimSeatType dstt ON f.DimSeatTypeId = dstt.DimSeatTypeId
	GROUP BY f.DimEventId
	, dtt.TicketTypeName
	, dpt.PlanTypeName
	, dstt.SeatTypeName
	, dtt.DimTicketTypeId
	, dpt.DimPlanTypeId
	, dstt.DimSeatTypeId
	, f.PriceCode
	, f.IsComp, f.RetailTicketType, f.RetailQualifiers
	)a
	--DROP TABLE #stgSales2
/**************** Staging sales temp Table #3 ****************/

SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, f.TicketTypeName, f.PlanTypeName, f.SeatTypeName, f.DimTicketTypeId, f.DimPlanTypeId, f.DimSeatTypeId 
, CASE WHEN SeatTypeName in ('Suite') AND f.IsComp = '0' THEN 'Suite' 
WHEN SeatTypeName in ('Suite') AND f.IsComp = '1' THEN 'Comp Ticket'  ELSE f.TicketTypeName END AS Section1
, CASE WHEN (f.PlanTypeName IN ('Unknown', 'No Plan') ) THEN 'SG'
	ELSE f.PlanTypeName END AS Section2
,f.SeatTypeName AS SeatTypeName2, f.retailtickettype ,f.retailqualifiers
,  f.Qty, f.Rev, NULL capacity
INTO #stgSales3 
FROM #stgSales2 f
INNER JOIN #Events e ON f.DimEventId = e.DimEventId
--WHERE e.DimEventId = 36
--ORDER BY SeatTypeName2
--DROP TABLE #stgSales3


SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, f.TicketTypeName, f.PlanTypeName, f.SeatTypeName, f.SeatTypeName2
, f.DimTicketTypeID, f.DimPlanTypeId, f.DimSeatTypeId , f.Section1, f.Section2
,  (f.Section2 + ' ' + REPLACE(f.SeatTypeName2, 'GA', '')) AS SeatTypeDrill
, SUM(f.Qty) Qty, SUM(f.Rev) Rev, NULL capacity
INTO #ROLoad
FROM #stgSales3 f
INNER JOIN #Events e ON f.DimEventId = e.DimEventId
--WHERE e.DimEventId = 36
GROUP BY e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, f.TicketTypeName, f.PlanTypeName, f.SeatTypeName, f.SeatTypeName2
, f.DimTicketTypeID, f.DimPlanTypeId, f.DimSeatTypeId , f.Section1, f.Section2
,  (f.Section2 + ' ' + REPLACE(f.SeatTypeName2, 'GA', '')), capacity
--DROP TABLE #ROLoad

/**************** Report Output Table ****************/

INSERT INTO #ReportOutput (DimEventId, EventName, EventDate, EventTime, EventDayOfWeek, Section1, Section2, SeatTypeDrill, Qty, Rev, Capacity)
(
SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, f.Section1, f.Section2, f.SeatTypeDrill
, f.Qty, f.Rev, NULL capacity
FROM #ROLoad f
INNER JOIN #Events e ON f.DimEventId = e.DimEventId
--WHERE e.DimEventId = 36
--GROUP BY e.DimEventId, f.seattypedrill, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, f.Section1, f.Section2, f.Qty, f.Rev, capacity
)
--DROP TABLE #ReportOutput

/****************Sort Order Table****************/
CREATE TABLE #ReportSortOrder
(
 DimEventId NVARCHAR(255)
, TicketTypeName VARCHAR (100)
, PlanTypeName VARCHAR (100)
, SeatTypeName VARCHAR (100)
, Section_Sort_Order INT 
, Line_Sort_Order int
)
INSERT INTO #ReportSortOrder
        ( DimEventId ,
          TicketTypeName ,
		  PlanTypeName,
		  SeatTypeName,
		  Section_Sort_Order ,
		  Line_Sort_Order
        )
		(
		SELECT  f.DimEventId, f.TicketTypeName , f.PlanTypeName, f.SeatTypeName
		--, r.SeatTypeDrill
		, CASE WHEN f.DimTicketTypeId = '1' AND f.DimSeatTypeId NOT IN ('-1', '2', '3' ) THEN 1 -- FS
		  WHEN f.DimTicketTypeId = '2' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' ) THEN 2 --HS
		  WHEN f.DimTicketTypeId = '3' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' ) THEN 3 --13G9
		  WHEN f.DimTicketTypeId = '4' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' ) THEN 4 --6GP
		  WHEN f.DimTicketTypeId = '5' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' ) THEN 5 --Flex
		  WHEN f.DimTicketTypeId = '9' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' ) THEN 6 --Other
		  WHEN f.DimTicketTypeId = '6' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' )THEN 7  --Group  /* How do I differentiate sold v. reserved? */
		  WHEN f.DimTicketTypeId IN ('-1', '7') AND f.DimSeatTypeId NOT IN ( '-1','2', '3' )THEN 8 --Single Game
		  WHEN f.DimTicketTypeId IN ('-1', '7') AND f.DimSeatTypeId in ( '-1')THEN 8 --Single Game
		  WHEN f.DimSeatTypeId IN ('2', '3') AND f.DimSeatTypeId NOT IN ( '1') AND f.DimPlanTypeId <> '-1'  THEN 9 --Suites
		  WHEN f.DimTicketTypeId = '8' AND f.DimSeatTypeId NOT IN ( '-1','2', '3' )THEN 10
		  WHEN f.DimTicketTypeId = '10' THEN 12 --Comps
		  ELSE 99 --unknown
		  END AS Section_Sort_Order
		, CASE 
		  WHEN f.DimTicketTypeId = '1' AND f.DimPlanTypeId = '1' THEN 101
		  WHEN f.DimTicketTypeId = '1' AND f.DimPlanTypeId = '2'  THEN 102
		  WHEN f.DimTicketTypeId = '2' AND f.DimPlanTypeId = '1'  THEN 201
		  WHEN f.DimTicketTypeId = '2' AND f.DimPlanTypeId = '2' THEN 202
		  WHEN f.DimTicketTypeId = '2' AND f.DimPlanTypeId = '5' THEN 203
		  WHEN f.DimTicketTypeId = '3' AND f.DimPlanTypeId = '1' THEN 301
		  WHEN f.DimTicketTypeId = '3' AND f.DimPlanTypeId = '2' THEN 302
		  WHEN f.DimTicketTypeId = '3' AND f.DimPlanTypeId = '5' THEN 303
		  WHEN f.DimTicketTypeId = '4' AND f.DimPlanTypeId = '1' THEN 401
		  WHEN f.DimTicketTypeId = '4' AND f.DimPlanTypeId = '2' THEN 402
		  WHEN f.DimTicketTypeId = '4' AND f.DimPlanTypeId = '5' THEN 403
		  WHEN f.DimTicketTypeId = '5' AND f.DimPlanTypeId = '3' THEN 501
		  WHEN f.DimTicketTypeId = '6' AND f.DimPlanTypeId = '7' THEN 601
		  WHEN f.DimTicketTypeId in ('7') AND f.DimPlanTypeId = '7' THEN 701
		  WHEN f.DimTicketTypeId in ('-1') AND f.DimPlanTypeId = '-1' THEN 701
		  WHEN f.DimTicketTypeId = '1' AND f.DimSeatTypeId = '2' THEN 901
		  WHEN f.DimTicketTypeId = '7' AND f.DimSeatTypeId = '2' THEN 902
		  WHEN f.DimTicketTypeId = '1' AND f.DimSeatTypeId = '3' THEN 903
		  WHEN f.DimTicketTypeId = '7' AND f.DimSeatTypeId = '3' THEN 904
		  WHEN f.DimTicketTypeId = '10' AND f.DimSeatTypeId = '1'  THEN 1001
		  WHEN f.DimTicketTypeId = '10' AND f.DimSeatTypeId IN ('2', '3') THEN 1002
		  ELSE 9999
		END AS Line_Sort_Order
		FROM #stgSales f)
		--left JOIN #stgSales3 f3 ON f3.DimEventId = f.DimEventId
		--right  JOIN #ROLoad r ON  r.Section1 = f3.Section1 
		--WHERE 1=1
		--WHERE f.DimEventId = '36'
		--ORDER BY f.DimEventId, Section_Sort_Order, Line_Sort_Order
		--DROP TABLE #ReportSortOrder

/** Velocity Table **/

CREATE TABLE #Velocity
(
 DimEventId NVARCHAR(40),EventName varchar (100),EventDate VARCHAR (20),EventTime VARCHAR (30),EventDayOfWeek VARCHAR (20),
Qty1 int , Rev1 INT, Qty7 int ,Rev7 INT,Qty14 INT, Rev14 INT, Qty30 int ,Rev30 INT ) 
--DROP TABLE #Velocity

DECLARE @1DayStartDate INT = (SELECT CONVERT(VARCHAR(8), (DATEADD(DAY, -1, GETDATE())), 112))
DECLARE @7DayStartDate INT = (SELECT CONVERT(VARCHAR(8), (DATEADD(DAY, -7, GETDATE())), 112))
DECLARE @14DayStartDate INT = (SELECT CONVERT(VARCHAR(8), (DATEADD(DAY, -14, GETDATE())), 112))
DECLARE @30DayStartDate INT = (SELECT CONVERT(VARCHAR(8), (DATEADD(DAY, -30, GETDATE())), 112))

INSERT INTO #Velocity
        ( DimEventId , EventName ,EventDate ,EventTime , EventDayOfWeek ,Qty1 ,Rev1, Qty7 , Rev7, Qty14, Rev14, Qty30, Rev30
        )
(
SELECT 
v.DimEventId, v.EventName, v.EventDate, v.EventTime, v.EventDayOfWeek, v.Qty1, v.Rev1, v.Qty7, v.Rev7, v.Qty14, v.Rev14, v.Qty30, v.Rev30
FROM 
(
SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek  
, SUM(QtySeat) Qty1
, SUM(fts.TotalRevenue) Rev1
, NULL Qty7, NULL Rev7, NULL Qty14, NULL Rev14, NULL Qty30, NULL Rev30
FROM dbo.FactTicketSales fts
INNER JOIN #Events e ON e.DimEventId = fts.DimEventId
WHERE fts.DimSeasonId = 37 AND fts.DimEventId > 0 
       AND fts.DimDateId >= @1DayStartDate
GROUP BY e.DimEventId,  e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek 

UNION ALL 
SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek  
, NULL Qty1, NULL Rev1
, SUM(QtySeat) Qty7
, SUM(fts.TotalRevenue) Rev7
, NULL Qty14, NULL Rev14, NULL Qty30, NULL Rev30
FROM dbo.FactTicketSales fts
INNER JOIN #Events e ON e.DimEventId = fts.DimEventId
WHERE fts.DimSeasonId = 37 AND fts.DimEventId > 0 
       AND fts.DimDateId >= @7DayStartDate
GROUP BY e.DimEventId,  e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek 

UNION ALL 
SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek  
, NULL Qty1, NULL Rev1, NULL Qty7, NULL Rev7
, SUM(QtySeat) Qty14
, SUM(fts.TotalRevenue) Rev14
, NULL Qty30, NULL Rev30
FROM dbo.FactTicketSales fts
INNER JOIN #Events e ON e.DimEventId = fts.DimEventId
WHERE fts.DimSeasonId = 37 AND fts.DimEventId > 0 
       AND fts.DimDateId >= @14DayStartDate
GROUP BY e.DimEventId,  e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek 

UNION ALL 
SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek  
, NULL Qty1, NULL Rev1, NULL Qty7, NULL Rev7, NULL Qty14, NULL Rev14
, SUM(QtySeat) Qty30
, SUM(fts.TotalRevenue) Rev30
FROM dbo.FactTicketSales fts
INNER JOIN #Events e ON e.DimEventId = fts.DimEventId
WHERE fts.DimSeasonId = 37 AND fts.DimEventId > 0 
       AND fts.DimDateId >= @30DayStartDate
GROUP BY e.DimEventId,  e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek 
) v )
--SELECT * FROM #Velocity v ORDER BY v.DimEventId

/** CAPACITY TABLE **/
		SELECT x.DimEventId, x.EventName, x.EventDate, x.EventTime, x.EventDayOfWeek, x.Capacity, z.TotalSold, z.TotalComp, z.TotalDistributed, y.RemainingInventory
		INTO #Capacity
		FROM 
		(SELECT dfi.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, COUNT(IsSaleable) Capacity 
		FROM dbo.FactInventory dfi 
		INNER JOIN #Events e ON e.DimEventId = dfi.DimEventId
		WHERE IsSaleable = 1
		GROUP BY dfi.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek
		) x
		left OUTER JOIN (
		SELECT dfi.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek,  COUNT(*) RemainingInventory
		FROM dbo.FactInventory dfi 
		INNER JOIN #Events e ON e.DimEventId = dfi.DimEventId
		WHERE dfi.IsSaleable = 1 AND dfi.IsSold = 0
		GROUP BY dfi.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek
		) y ON y.DimEventId = x.DimEventId
		left OUTER JOIN
		(SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, SUM(fts.QtySeat) TotalDistributed , (SUM(fts.QtySeat) - SUM(fts.IsComp)) TotalSold 
		, SUM(fts.IsComp) TotalComp
		FROM dbo.FactTicketSales fts
		INNER JOIN #Events e ON e.DimEventId = fts.DimEventId
		GROUP BY e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek
		) z ON z.DimEventId = x.DimEventId
	
/** Day -1 Snapshot **/
SELECT dfi.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, SUM(dfi.QtySeat)  TotalDistributedDay1
INTO #Snapshot
FROM dbo.FactTicketSales dfi
		INNER JOIN #Events e ON e.DimEventId = dfi.DimEventId
		WHERE 
		
		 dfi.DimDateId < @1DayStartDate
		GROUP BY dfi.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek
		

/*** Results ***/
SELECT x.DimEventId, x.EventName, x.EventDate, x.EventTime, x.EventDayOfWeek, x.Section1, x.SeatTypeDrill, x.Qty, x.Revenue, x.Section_Sort_Order, x.Line_Sort_Order
FROM
(
SELECT
    ro.DimEventId, ro.EventName, ro.EventDate, ro.EventTime, ro.EventDayOfWeek, ro.Section1, ro.Section2
	, ro.SeatTypeDrill,  ro.Qty Qty, ro.Rev Revenue
	, sor.Section_Sort_Order Section_Sort_Order, sor.Line_Sort_Order Line_Sort_Order
FROM
    #ROLoad ro
    LEFT JOIN #ReportSortOrder sor ON sor.DimEventId = ro.DimEventId AND sor.TicketTypeName = ro.TicketTypeName 
	AND sor.PlanTypeName = ro.PlanTypeName AND sor.SeatTypeName = ro.SeatTypeName 
UNION ALL 
	SELECT c.DimEventId, c.EventName, c.EventDate, c.EventTime, c.EventDayOfWeek, 'Capacity', NULL, NULL, Capacity, NULL, 99999, 99999
	FROM #Capacity c
UNION ALL 
	SELECT c.DimEventId, c.EventName, c.EventDate, c.EventTime, c.EventDayOfWeek, 'Total Sold', NULL, NULL, TotalSold, NULL, 112, 99999
	FROM #Capacity c
UNION ALL 
	SELECT c.DimEventId, c.EventName, c.EventDate, c.EventTime, c.EventDayOfWeek, 'Total Distributed', NULL, NULL, TotalDistributed, NULL, 114, 99999
	FROM #Capacity c
UNION ALL 
	SELECT c.DimEventId, c.EventName, c.EventDate, c.EventTime, c.EventDayOfWeek, 'Remaining Inventory', NULL, NULL, RemainingInventory, NULL, 115, 99999
	FROM #Capacity c
UNION ALL 
	SELECT s.DimEventId, s.EventName, s.EventDate, s.EventTime, s.EventDayOfWeek, 'Snap Shot Total Distributed', NULL, NULL, TotalDistributedDay1, NULL, 116, 99999
	FROM #Snapshot s
UNION ALL
	SELECT v.DimEventId, v.EventName, v.EventDate, v.EventTime, v.EventDayOfWeek, '1 Day Velocity', NULL, NULL, v.Qty1, v.Rev1  , 999990, 999990
	FROM #Velocity v 
	WHERE v.Qty1 IS NOT NULL AND v.Rev1 IS NOT NULL
UNION ALL 
	SELECT v.DimEventId, v.EventName, v.EventDate, v.EventTime, v.EventDayOfWeek, '7 Day Velocity', NULL, NULL, v.Qty7, v.Rev7  , 999990, 999991
	FROM #Velocity v 
	WHERE v.Qty7 IS NOT NULL AND v.Rev7 IS NOT NULL
UNION ALL 
	SELECT v.DimEventId, v.EventName, v.EventDate, v.EventTime, v.EventDayOfWeek, '14 Day Velocity', NULL, NULL, v.Qty14, v.Rev14  , 999990, 999992
	FROM #Velocity v 
	WHERE v.Qty14 IS NOT NULL AND v.Rev14 IS NOT NULL
UNION ALL 
	SELECT v.DimEventId, v.EventName, v.EventDate, v.EventTime, v.EventDayOfWeek, '30 Day Velocity', NULL, NULL, v.Qty30, v.Rev30  , 999990, 999993
	FROM #Velocity v 
	WHERE v.Qty30 IS NOT NULL AND v.Rev30 IS NOT NULL
	)x
	--WHERE x.DimEventId = 36
	GROUP BY x.DimEventId, x.EventName, x.EventDate, x.EventTime, x.EventDayOfWeek, x.Section1, x.SeatTypeDrill, x.Qty, x.Revenue, x.Section_Sort_Order, x.Line_Sort_Order
ORDER BY
    x.DimEventId, x.Section_Sort_Order, x.Line_Sort_Order
	



--END









GO
