SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- View




CREATE VIEW  [mdm].[vw_MDM_Rules] AS
(
SELECT dc.dimcustomerid
, lp.LP 
, sth.STH
, pp.PP
, g.GRP
, NULL Concert --Placeholder for Concert rule; Ameitin 2017/05/21
, crm.CRM_ActivityDate
, sc.MaxSeatCount
, maxPurchaseDate
, dc.accountid
FROM dbo.dimcustomer dc
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'LP' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId = 1 AND dd.CalDate >= (GETDATE()-730)) lp ON dc.dimcustomerid = lp.dimcustomerid
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'STH' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId = 2 AND dd.CalDate >= (GETDATE()-730)) sth ON dc.dimcustomerid = sth.dimcustomerid
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'PP' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId IN (3,4) AND dd.CalDate >= (GETDATE()-730)) pp ON dc.dimcustomerid = pp.dimcustomerid
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, 1 AS 'GRP' FROM dbo.factticketsales a
	LEFT JOIN dbo.dimdate dd ON a.DimDateId_OrigSale = dd.DimDateId
	WHERE a.DimTicketTypeId = 5 AND dd.CalDate >= (GETDATE()-730)) g ON dc.dimcustomerid = g.dimcustomerid
LEFT JOIN (
	SELECT DISTINCT dimcustomerid, MAX(ModifiedOn) AS 'CRM_ActivityDate' FROM Oilers_Reporting.[prodcopy].[vw_Contact] a
	INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc on dc.SourceSystem = 'CRM_Contact' AND  CAST(a.contactid AS NVARCHAR(50)) = dc.SSID
	GROUP BY dc.dimcustomerid
	) crm ON dc.dimcustomerid = crm.dimcustomerid
LEFT JOIN (
		SELECT a.DimCustomerId, (ISNULL(a.FTS,0) + ISNULL(a.FTSH,0) + ISNULL(a.TEX,0)) MaxSeatCount
		FROM (
			SELECT f.dimcustomerid, SUM(f.QtySeat) FTS, SUM(fh.QtySeat) FTSH, SUM(tx.num_seats) TEX
			FROM dbo.FactTicketSales f WITH (NOLOCK)
			LEFT JOIN dbo.FactTicketSalesHistory fh WITH (NOLOCK) ON f.DimCustomerId = fh.DimCustomerId
			LEFT JOIN ods.TM_Tex tx WITH (NOLOCK) ON f.SSID_acct_id = tx.assoc_acct_id
			JOIN dbo.dimdate dd ON f.DimDateId_OrigSale = dd.DimDateId
			WHERE dd.CalDate > = (GETDATE() - 730)
			GROUP BY f.DimCustomerId) a) sc ON dc.DimCustomerId = sc.DimCustomerId
LEFT JOIN (
	SELECT dimcustomerid, MAX(maxtransdate) maxPurchaseDate 
	FROM (
		SELECT f.DimCustomerID, MAX(dd.CalDate) MaxTransDate , 'Oilers' Team
		--Select * 
		FROM dbo.FactTicketSales f WITH(NOLOCK)
		INNER JOIN dbo.DimDate  dd WITH(NOLOCK) ON dd.DimDateId = f.DimDateId
		WHERE dd.CalDate >= (GETDATE() - 730)
		GROUP BY f.[DimCustomerId]

		UNION ALL 

		SELECT f.DimCustomerID, MAX(dd.CalDate) MaxTransDate , 'Oilers' Team
		--Select * 
		FROM dbo.FactTicketSaleshistory f WITH(NOLOCK)
		INNER JOIN dbo.DimDate  dd WITH(NOLOCK) ON dd.DimDateId = f.DimDateId
		WHERE dd.CalDate >= (GETDATE() - 730)
		GROUP BY f.[DimCustomerId]

		UNION ALL
		SELECT dc.dimcustomerid, MAX(tex.add_datetime) MaxTransDate, 'Oilers' Team
		FROM ods.TM_Tex tex WITH (NOLOCK)
		LEFT JOIN dbo.dimcustomer dc WITH (NOLOCK) ON tex.assoc_acct_id = dc.accountid AND dc.customertype = 'Primary' AND dc.sourcesystem = 'TM'
		WHERE tex.add_datetime >= (GETDATE() - 730)
		GROUP BY dc.dimcustomerid
		) x
		GROUP BY x.dimcustomerid, x.team
	) purchasedate ON purchasedate.DimCustomerId = dc.DimCustomerId





)











GO
