SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [etl].[BETA_Cust_FactTicketSalesProcessing]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(MAX) = NULL 
)
AS



BEGIN



/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/

----LICENSED SEASON----

UPDATE fts

SET fts.DimTicketTypeId = 1
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE '1%'


----FULL SEASON ----

UPDATE fts
SET fts.DimTicketTypeId = 2
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE PriceCode.PriceCodeGroup LIKE  '2%'


----MINI----

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '3%'


----FLEX----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '4%'

----GROUP----

UPDATE fts
SET fts.DimTicketTypeId = 5
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '5%'

----RETAIL (SINGLES)----

UPDATE fts
SET fts.DimTicketTypeId = 6
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '6%' OR (fts.ishost =1 AND fts.DimTicketTypeId = -1)


----LEVERAGED ----

UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '7%'


----COMP ----

UPDATE fts
SET fts.DimTicketTypeId = 8
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '8%'

----REDEMPTIONS ----

UPDATE fts
SET fts.DimTicketTypeId = 9
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  '9%'

----Preprints ----

UPDATE fts
SET fts.DimTicketTypeId = 11
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  'x%'

----Vouchers ----

UPDATE fts
SET fts.DimTicketTypeId = 12
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
WHERE	PriceCode.PriceCodeGroup LIKE  'v%'



----MISC----

--UPDATE fts
--SET fts.DimTicketTypeId = 14
--FROM    stg.TM_FactTicketSales fts
--        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
--        JOIN etl.vw_DimSeason season ON season.DimSeasonId = fts.DimSeasonId
--WHERE	(season.SeasonName LIKE '%2015%' OR season.SeasonName LIKE '%2016%')
--		AND DimTicketTypeId = -1



/*****************************************************************************************************************
															PLAN TYPE
******************************************************************************************************************/

----NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason dimseason ON dimseason.dimseasonid = fts.dimseasonID
WHERE   dimseason.seasonname LIKE 'NHL%'
		and PriceCode.PC2 IN ('N','M')
		--OR PriceCode.PC3 = 'N'
		--OR PriceCode.PC4 = 'N'

		-- Oil Kings
		OR (dimseason.seasonname LIKE 'WHL%' AND PriceCode.TM_ticket_type LIKE 'NEW%')
	

----RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason dimseason ON dimseason.dimseasonid = fts.dimseasonID
WHERE   PriceCode.PC2 IN ('R', 'U')
		--OR PriceCode.PC3 IN ('R', 'U')
		--OR PriceCode.PC4 IN ('R', 'U')
		
		--Oil Kings
		OR(dimseason.seasonname LIKE 'WHL%'  AND (PriceCode.TM_ticket_type LIKE 'NEW%' OR PriceCode.TM_ticket_type LIKE 'Ren%'))

----NO PLAN----


UPDATE fts
SET fts.DimPlanTypeId = 7
FROM    stg.TM_FactTicketSales fts
		JOIN etl.vw_DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE   (season.SeasonName LIKE '%2015%' OR season.SeasonName LIKE '%2016%' OR season.SeasonName LIKE '%2017%')
		AND fts.DimPlanTypeId = -1


/*****************************************************************************************************************
															SEAT TYPE
******************************************************************************************************************/

----Chairmans Club----

UPDATE fts
SET fts.DimSeatTypeId = 1
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE  dimSeat.DefaultPriceCode = '1'
		--PC1 = '1'
	
----SUITES----

UPDATE fts
SET fts.DimSeatTypeId = 2
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE  dimSeat.DefaultPriceCode = '2'
		--PC1 = '2'
	   
----THEATRE BOX----

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE  dimSeat.DefaultPriceCode = '3'
		--PC1 = '3'
	   
	   
----LOGE TABLE----

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE  dimSeat.DefaultPriceCode = '4'
		--PC1 = '4'

----LOGE lEDGE----

UPDATE fts
SET fts.DimSeatTypeId = 5 
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE  dimSeat.DefaultPriceCode = '5'
		--PC1 = '5'

----SPORTSNET CLUB----

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE (SeasonName LIKE 'NHL%' OR SeasonName LIKE 'WHL%' OR SeasonName LIKE 'OEG%' OR SeasonName LIKE 'PBR%')
	  AND dimSeat.DefaultPriceCode IN ('6','7','S')
	  -- AND  PC1 IN ('6','7')

----Sky Lounge----

UPDATE fts
SET fts.DimSeatTypeId = 7
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE (SeasonName LIKE 'NHL%' OR SeasonName LIKE 'WHL%' OR SeasonName LIKE 'OEG%' OR SeasonName LIKE 'PBR%')
	   AND dimSeat.DefaultPriceCode IN ('8','9','T')
	   --AND  PC1 IN ('8','9')


---Lower Club----

UPDATE fts
SET fts.DimSeatTypeId = 8
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE (SeasonName LIKE 'NHL%' AND  dimSeat.DefaultPriceCode IN ('A','B', 'C', 'D', 'E'))
		OR (SeasonName LIKE 'WHL%' AND dimSeat.DefaultPriceCode = 'A')
		--2017 Oil Kings
		OR (SeasonName LIKE 'WHL%' AND dimSeat.DefaultPriceCode in ('A','B', 'C', 'D', 'E'))
		--2017 Concert
		OR ((SeasonName LIKE 'OEG%' OR SeasonName LIKE 'PBR%') AND dimSeat.DefaultPriceCode in ('A','B', 'C', 'D', 'E'))
	
---Lower Bowl----

UPDATE fts
SET fts.DimSeatTypeId = 9
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start

WHERE (SeasonName LIKE 'NHL%' AND  DefaultPriceCode IN ('F','G', 'H', 'I', 'J'))
		--2016 Oil Kings
		OR (SeasonName LIKE 'WHL%' AND DefaultPriceCode IN ('B', 'C', 'D', 'E'))
		--2017 Oil Kings
		OR (SeasonName LIKE 'WHL%' AND DefaultPriceCode IN ('F','G', 'H', 'I', 'J'))
		--2017 Concert
		OR ((SeasonName LIKE 'OEG%' OR SeasonName LIKE 'PBR%') AND DefaultPriceCode in ('F','G', 'H', 'I', 'J'))


--(SeasonName LIKE 'NHL%' AND  PC1 IN ('F','G', 'H', 'I', 'J'))
--	OR (SeasonName LIKE 'WHL%' AND PC1 IN ('B', 'C', 'D', 'E'))


----UPPER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 10 
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE (ds.SeasonName LIKE 'NHL%' AND  DefaultPriceCode IN ('L','M', 'N', 'O', 'P', 'Q'))
		--2016 Oil Kings
		OR (ds.SeasonName LIKE 'WHL%' AND dimseat.DefaultPriceCode = 'L')
		--2017 Oil Kings
		OR (ds.SeasonName LIKE 'WHL%' AND dimseat.DefaultPriceCode IN ('L','M', 'N', 'O', 'P', 'Q'))
		--2017Concerts
		OR ((ds.SeasonName LIKE 'OEG%' OR ds.SeasonName LIKE 'PBR%') AND DefaultPriceCode IN  ('L','M', 'N', 'O', 'P', 'Q'))


--(SeasonName LIKE 'NHL%' AND  PC1 IN ('L','M', 'N', 'O', 'P', 'Q'))
--OR (SeasonName LIKE 'WHL%' AND PC1 = 'L')

----Voucher----

UPDATE fts
SET fts.DimSeatTypeId = 11 
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE ds.SeasonName LIKE 'WHL%' AND dimseat.DefaultPriceCode IN ('V')

----Pass----

UPDATE fts
SET fts.DimSeatTypeId = 12
FROM   stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
		INNER JOIN etl.vw_DimSeat dimseat ON dimseat.dimseatID = fts.DimSeatId_Start
WHERE ds.SeasonName LIKE 'NHL%' AND  dimseat.DefaultPriceCode IN ('U','V','W','X')


/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/

--IsComp TRUE--

UPDATE f
SET f.IsComp = 1
FROM stg.TM_FactTicketSales f
	JOIN etl.vw_DimPriceCode dpc
	ON dpc.DimPriceCodeId = f.DimPriceCodeId
WHERE f.TM_comp_code <> '0'

--IsComp FALSE--

UPDATE f
SET f.IsComp = 0
FROM stg.TM_FactTicketSales f
	JOIN etl.vw_DimPriceCode dpc
	ON dpc.DimPriceCodeId = f.DimPriceCodeId
WHERE NOT (f.TM_comp_name <> 'Not Comp')
		   --OR PriceCodeDesc = 'Comp'
		   --OR f.TotalRevenue = 0)

--IsPlan TRUE--

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM stg.TM_FactTicketSales f
WHERE f.DimTicketTypeId IN ('1','2','3','4') 
--/*Licensed Season, Full Season, Mini Plan, Flex Plan */

--Is Partial Plan--

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM stg.TM_FactTicketSales f
WHERE f.DimTicketTypeId IN ('3','4') 
--/*Mini Plan, Flex Plan */



--Is Group--

UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM stg.TM_FactTicketSales f
WHERE f.DimTicketTypeId IN ('5') 
--/*Group */

--Is Single, not Group--

UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM stg.TM_FactTicketSales f
WHERE f.DimTicketTypeId IN ('6') 
--/*Single Game*/


--is Premium TRUE--

UPDATE f
SET f.IsPremium = 1
FROM stg.TM_FactTicketSales  f
INNER JOIN etl.vw_DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.DimSeatTypeId IN ('1', '2', '3', '4', '5')

--is Premium FALSE--

UPDATE f
SET f.IsPremium = 0
FROM stg.TM_FactTicketSales f
INNER JOIN etl.vw_DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode IN ('-1', '6', '7', '8', '9', '10')

--is Renewal TRUE--

UPDATE f
SET f.IsRenewal = 1
FROM stg.TM_FactTicketSales f
INNER JOIN etl.vw_DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode IN ('RENEW')



--is Renewal FALSE--

UPDATE f
SET f.IsRenewal = 0
FROM stg.TM_FactTicketSales f
INNER JOIN etl.vw_DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode NOT IN ('RENEW')


---isBroker TRUE----

UPDATE f
SET f.IsBroker = 1 
FROM stg.TM_FactTicketSales f
INNER JOIN dbo.DimCustomer dc ON dc.DimCustomerId = f.DimticketCustomerId AND dc.SourceSystem = 'TM'
WHERE dc.AccountType = 'BR'







END 






















GO
