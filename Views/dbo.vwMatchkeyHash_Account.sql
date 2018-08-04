SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE   VIEW [dbo].[vwMatchkeyHash_Account]
AS 
--WITH XX AS 


SELECT 
a.dimcustomerid
,a.sourcesystem
,a.ssid
,a.IsDeleted
,xx.SSB_CRMSYSTEM_CONTACT_ID, xx.ExtAttribute7
FROM dbo.DimCustomer a
INNER JOIN dbo.dimcustomerssbid b ON a.DimCustomerId = b.DimCustomerId
INNER JOIN 
		(SELECT  b.SSB_CRMSYSTEM_CONTACT_ID , MAX(ExtAttribute7) ExtAttribute7
			FROM dbo.DimCustomer a
			INNER JOIN dbo.dimcustomerssbid b ON a.DimCustomerId = b.DimCustomerId
			GROUP BY b.SSB_CRMSYSTEM_CONTACT_ID) xx 
		ON b.SSB_CRMSYSTEM_CONTACT_ID = xx.SSB_CRMSYSTEM_CONTACT_ID
WHERE b.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
--GROUP BY xx.SSB_CRMSYSTEM_CONTACT_ID



GO
