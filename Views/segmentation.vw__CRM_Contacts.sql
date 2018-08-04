SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create VIEW [segmentation].[vw__CRM_Contacts] as
SELECT m.SSB_CRMSYSTEM_CONTACT_ID
	  ,c.ContactId
		,client_PRTheatreBoxContactType
	   ,client_PRTheatreBoxLocations
	   ,client_PRTheatreBoxSeats
	   ,client_PRTheatreBoxSROs
	   ,client_PRTheatreBoxTerm
	   ,client_PRSuspendConcertoffers
	   ,client_PRSuiteTerm
	   ,client_PRSuiteLocations
	   ,client_PRSuiteLicenseType
	   ,client_PRSuiteContactType
	   ,client_PRSuiteSROs
	   ,client_PRSuiteSeats
	   ,client_PRNoofClubOZoneSeats
	   ,client_PRLogeTableContactType
	   ,client_PRLogeTableLocations
	   ,client_PRLogeTableSeats
	   ,client_PRLogeTableTerm
	   ,client_PRLogeLedgeTerm
	   ,client_PRLogeLedgeLocations
	   ,client_PRLogeLedgeContactType
	   ,client_PRLogeLedgeSeats
	   ,client_PRContractOutstanding
	   ,client_PRContractNotes
	   ,client_PRContractExpireyDate
	   ,client_PRChairmansLocationss
	   ,client_PRChairmansSeats
	   ,client_PRChairmansTerm
	   ,client_PRArchticsAccount
--select count(*)
FROM Oilers_Reporting.prodcopy.Contact c
JOIN dbo.vwDimCustomer_ModAcctId m
ON c.ContactId = m.ssid AND sourcesystem = 'CRM_Contact'


	
GO
