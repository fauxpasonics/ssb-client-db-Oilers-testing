SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE  VIEW [segmentation].[vw__Source_System] AS 

(

SELECT  dc.SSB_CRMSYSTEM_CONTACT_ID
		, dc.SourceSystem CustomerSourceSystem

FROM    [dbo].[vwDimCustomer_ModAcctId] dc

WHERE dc.SourceSystem NOT IN ('TM', 'CRM_Contact') --excluding SourceSystems that they would not use for SourceSystem use cases to reduce count


) 

































GO
