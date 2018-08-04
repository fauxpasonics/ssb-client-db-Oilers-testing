SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN

-- CRM_Account
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Oilers', @LoadView = '[etl].[vw_Load_DimCustomer_CRM_Account]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

-- CRM_Contact
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Oilers', @LoadView = '[etl].[vw_Load_DimCustomer_CRM_Contact]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'



END





GO
