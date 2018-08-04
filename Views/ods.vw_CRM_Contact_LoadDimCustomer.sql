SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









/*****Hash Rules for Reference******
WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_INT'')'
WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIGINT'')'
WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'  
WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'
WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ',112)),''DBNULL_DATE'')' 
WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIT'')'  
WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
ELSE 'ISNULL(RTRIM(' + COLUMN_NAME + '),''DBNULL_TEXT'')'
*****/

CREATE VIEW [ods].[vw_CRM_Contact_LoadDimCustomer] AS (

	SELECT *
	/*Name*/
	, HASHBYTES('sha2_256',
							ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Fullname),'DBNULL_TEXT')
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')) AS [NameDirtyHash]
	, 'Dirty' AS [NameIsCleanStatus]
	, NULL AS [NameMasterId]

	/*Address*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [AddressPrimaryDirtyHash]
	, 'Dirty' AS [AddressPrimaryIsCleanStatus]
	, NULL AS [AddressPrimaryMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressOneStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressOneZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneCountry),'DBNULL_TEXT')) AS [AddressOneDirtyHash]
	, 'Dirty' AS [AddressOneIsCleanStatus]
	, NULL AS [AddressOneMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressTwoStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressTwoZip),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoCounty),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoCountry),'DBNULL_TEXT')) AS [AddressTwoDirtyHash]
	, 'Dirty' AS [AddressTwoIsCleanStatus]
	, NULL AS [AddressTwoMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressThreeStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressThreeZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeCountry),'DBNULL_TEXT')) AS [AddressThreeDirtyHash]
	, 'Dirty' AS [AddressThreeIsCleanStatus]
	, NULL AS [AddressThreeMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressFourStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressFourZip),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourCounty),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourCountry),'DBNULL_TEXT')) AS [AddressFourDirtyHash]
	, 'Dirty' AS [AddressFourIsCleanStatus]
	, NULL AS [AddressFourMasterId]

	/*Contact*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FullName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')+ ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [ContactDirtyHash]
	, CAST(NULL AS NVARCHAR(50)) AS [ContactGuid]

	/*Phone*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhonePrimary),'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
	, 'Dirty' AS [PhonePrimaryIsCleanStatus]
	, NULL AS [PhonePrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneHome),'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
	, 'Dirty' AS [PhoneHomeIsCleanStatus]
	, NULL AS [PhoneHomeMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneCell),'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
	, 'Dirty' AS [PhoneCellIsCleanStatus]
	, NULL AS [PhoneCellMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneBusiness),'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
	, 'Dirty' AS [PhoneBusinessIsCleanStatus]
	, NULL AS [PhoneBusinessMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
	, 'Dirty' AS [PhoneFaxIsCleanStatus]
	, NULL AS [PhoneFaxMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
	, 'Dirty' AS [PhoneOtherIsCleanStatus]
	, NULL AS [PhoneOtherMasterId]

	/*Email*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailPrimary),'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
	, 'Dirty' AS [EmailPrimaryIsCleanStatus]
	, NULL AS [EmailPrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailOne),'DBNULL_TEXT')) AS [EmailOneDirtyHash]
	, 'Dirty' AS [EmailOneIsCleanStatus]
	, NULL AS [EmailOneMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailTwo),'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
	, 'Dirty' AS [EmailTwoIsCleanStatus]
	, NULL AS [EmailTwoMasterId]

	/*External Attributes*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(customerType),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CustomerStatus),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AccountType),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AccountRep),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(SalutationName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(DonorMailName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(DonorFormalName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Birthday),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(Gender),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AccountId),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedRecordFlag),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedIntoSSID),'DBNULL_TEXT')
							+ ISNULL(RTRIM(IsBusiness),'DBNULL_TEXT')) AS [contactattrDirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute1),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute2),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute3),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute4),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute5),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute6),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute7),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute8),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute9),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute10),'DBNULL_TEXT') 
							) AS [extattr1_10DirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute11),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute12),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute13),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute14),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute15),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute16),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute17),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute18),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute19),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute20),'DBNULL_TEXT') 
							) AS [extattr11_20DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute21),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute22),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute23),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute24),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute25),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute26),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute27),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute28),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute29),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute30),'DBNULL_TEXT') 
							) AS [extattr21_30DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute31),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute32),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute33),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute34),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute35),'DBNULL_TEXT')
							) AS [extattr31_35DirtyHash]

	FROM (
--base set

		SELECT 'MSCRM' AS [SourceDB]
		, 'CRM_Contact' AS [SourceSystem]
		, 1 AS [SourceSystemPriority]
		, CAST(c.contactid AS NVARCHAR(50)) AS [SSID]

		/*Standard Attributes*/
		, NULL AS [CustomerType]
		, NULL AS [CustomerStatus]
		, NULL AS [AccountType] 
		, NULL AS [AccountRep] 
		, c.[kore_accountaliasid] AS [CompanyName] 
		, NULL AS [SalutationName]
		, NULL AS [DonorMailName]
		, NULL AS [DonorFormalName]
		, [BirthDate] AS [Birthday]
		, CASE WHEN c.gendercode = 2 THEN 'F' WHEN c.gendercode = 1 THEN 'M' ELSE NULL END AS [Gender] 
		, 0 [MergedRecordFlag]
		, NULL [MergedIntoSSID]

		/**ENTITIES**/
			/*Name*/

		, NULL AS [Prefix]
		, c.firstname AS [FirstName]
		, c.middlename AS [MiddleName]
		, c.lastname AS [LastName]
		, c.fullname AS [FullName]
		, c.suffix AS [Suffix]
		--, c.name_title as [Title]

		/*AddressPrimary*/
            , CONCAT(c.address1_line1,' ',c.address1_line2, ' ' ,c.address1_line3) AS [AddressPrimaryStreet]
			, c.address1_city AS [AddressPrimaryCity] 
			, c.address1_stateorprovince	AS [AddressPrimaryState] 
			, c.address1_postalcode	AS [AddressPrimaryZip] 
			, c.address1_county AS [AddressPrimaryCounty]
			, c.address1_country	AS [AddressPrimaryCountry] 
			, CONCAT(c.address2_line1,' ',c.address2_line2, ' ' ,c.address2_line3)  AS [AddressOneStreet]
			, c.address2_city AS [AddressOneCity] 
			, c.address2_stateorprovince AS [AddressOneState] 
			, c.address2_postalcode AS [AddressOneZip] 
			, c.address2_county AS [AddressOneCounty] 
			, c.address2_country AS [AddressOneCountry] 
			, NULL AS [AddressTwoStreet]
			, NULL AS [AddressTwoCity] 
			, NULL AS [AddressTwoState] 
			, NULL AS [AddressTwoZip] 
			, NULL AS [AddressTwoCounty] 
			, NULL AS [AddressTwoCountry] 
			, NULL AS [AddressThreeStreet]
			, NULL AS [AddressThreeCity] 
			, NULL AS [AddressThreeState] 
			, NULL AS [AddressThreeZip] 
			, NULL AS [AddressThreeCounty] 
			, NULL AS [AddressThreeCountry] 
			, NULL AS [AddressFourStreet]
			, NULL AS [AddressFourCity] 
			, NULL AS [AddressFourState] 
			, NULL AS [AddressFourZip] 
			, NULL AS [AddressFourCounty]
			, NULL AS [AddressFourCountry] 
	
			/*Phone*/
			, LEFT(c.telephone1,25) AS [PhonePrimary]
			, LEFT(c.telephone2,25) AS [PhoneHome]
			, LEFT(c.mobilephone,25) AS [PhoneCell]
			, LEFT(c.telephone1,25) AS [PhoneBusiness]
			, LEFT(c.fax,25) AS [PhoneFax]
			, NULL AS [PhoneOther]

			/*Email*/
			, c.emailaddress1 AS [EmailPrimary]
			, c.emailaddress2 AS [EmailOne]
			, c.emailaddress3 AS [EmailTwo]

			/*Extended Attributes*/
			--, CAST(c.[kore_CheckedOutById] AS NVARCHAR(50)) AS [ExtAttribute1] --nvarchar(100)
			, NULL AS [ExtAttribute1]
			, CAST(c.parentcustomerid AS NVARCHAR(50)) AS [ExtAttribute2] 
			, NULL AS[ExtAttribute3] 
			, NULL AS[ExtAttribute4] 
			, NULL AS[ExtAttribute5] 
			, NULL AS[ExtAttribute6] 
			, NULL AS[ExtAttribute7] 
			, NULL AS[ExtAttribute8] 
			, NULL AS[ExtAttribute9] 
			, NULL AS[ExtAttribute10] --nvarchar(1000)

			, NULL AS [ExtAttribute11]
			, CAST(c.donotemail AS DECIMAL) AS [ExtAttribute16] --decimal
			, CAST(c.donotpostalmail AS DECIMAL) AS [ExtAttribute12] 
			, CAST(c.donotphone AS DECIMAL) AS [ExtAttribute13] 
			, CAST(CASE
				WHEN c.address1_country IN ('CA','CAN','Canada') THEN 1 
				WHEN c.address1_stateorprovince IN ('ON','QC','NS','NB','MB','BC','PE','SK','AB','NL') THEN 1
				WHEN c.address2_country IN ('CA','CAN','Canada') THEN 1 
				WHEN c.address2_stateorprovince IN ('ON','QC','NS','NB','MB','BC','PE','SK','AB','NL') THEN 1
				WHEN c.emailaddress1 LIKE '%.CA' THEN 1
				WHEN c.emailaddress2 LIKE '%.CA' THEN 1
				WHEN c.emailaddress3 LIKE '%.CA' THEN 1
				WHEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.telephone1,'(',''),')',''),'-',''),'x',''),'.',''),' ','') ,3) IN ('204','226','236','249','250','289','306','343','365','403','416','418','431','437','438','450','506',
				'514','519','579','581','587','604','613','639','647','705','709','778','780','782','807','819','867','873','902','905') THEN 1
				WHEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.telephone1,'(',''),')',''),'-',''),'x',''),'.',''),' ','') ,3) IN ('204','226','236','249','250','289','306','343','365','403','416','418','431','437','438','450','506',
				'514','519','579','581','587','604','613','639','647','705','709','778','780','782','807','819','867','873','902','905') THEN 1
				WHEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.telephone1,'(',''),')',''),'-',''),'x',''),'.',''),' ','') ,3) IN ('204','226','236','249','250','289','306','343','365','403','416','418','431','437','438','450','506',
				'514','519','579','581','587','604','613','639','647','705','709','778','780','782','807','819','867','873','902','905') THEN 1
				ELSE c.donotbulkemail END AS DECIMAL) AS [ExtAttribute14] 
		    , CAST(CASE
				WHEN c.address1_country IN ('CA','CAN','Canada') THEN 1 
				WHEN c.address1_stateorprovince IN ('ON','QC','NS','NB','MB','BC','PE','SK','AB','NL') THEN 1
				WHEN c.address2_country IN ('CA','CAN','Canada') THEN 1 
				WHEN c.address2_stateorprovince IN ('ON','QC','NS','NB','MB','BC','PE','SK','AB','NL') THEN 1
				WHEN c.emailaddress1 LIKE '%.CA' THEN 1
				WHEN c.emailaddress2 LIKE '%.CA' THEN 1
				WHEN c.emailaddress3 LIKE '%.CA' THEN 1
				WHEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.telephone1,'(',''),')',''),'-',''),'x',''),'.',''),' ','') ,3) IN ('204','226','236','249','250','289','306','343','365','403','416','418','431','437','438','450','506',
				'514','519','579','581','587','604','613','639','647','705','709','778','780','782','807','819','867','873','902','905') THEN 1
				WHEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.telephone1,'(',''),')',''),'-',''),'x',''),'.',''),' ','') ,3) IN ('204','226','236','249','250','289','306','343','365','403','416','418','431','437','438','450','506',
				'514','519','579','581','587','604','613','639','647','705','709','778','780','782','807','819','867','873','902','905') THEN 1
				WHEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.telephone1,'(',''),')',''),'-',''),'x',''),'.',''),' ','') ,3) IN ('204','226','236','249','250','289','306','343','365','403','416','418','431','437','438','450','506',
				'514','519','579','581','587','604','613','639','647','705','709','778','780','782','807','819','867','873','902','905') THEN 1
				ELSE c.donotemail END AS DECIMAL) AS [ExtAttribute15] 
			, NULL AS [ExtAttribute17] 
			, NULL AS [ExtAttribute18] 
			, NULL AS [ExtAttribute19] 
			, NULL AS [ExtAttribute20]  

			, TRY_CAST (c.kore_lastcontacted AS DATE) AS [ExtAttribute21] --datetime
			, NULL AS [ExtAttribute22] 
			, NULL AS [ExtAttribute23] 
			, NULL AS [ExtAttribute24] 
			, NULL AS [ExtAttribute25] 
			, NULL AS [ExtAttribute26] 
			, NULL AS [ExtAttribute27] 
			, NULL AS [ExtAttribute28] 
			, NULL AS [ExtAttribute29] 
			, NULL AS [ExtAttribute30]  
			, NULL AS [ExtAttribute31]
			, NULL AS [ExtAttribute32]  
			, NULL AS [ExtAttribute33]  
			, NULL AS [ExtAttribute34]  
			, NULL AS [ExtAttribute35]  

	
			
			/*Source Created and Updated*/
	   	    , CAST(c.CreatedBy AS NVARCHAR(50)) AS [SSCreatedBy]
		    , CAST(c.ModifiedBy AS NVARCHAR(50)) AS [SSUpdatedBy]
			, TRY_CAST (c.CreatedOn AS DATE) AS [SSCreatedDate]
			, TRY_CAST (c.ModifiedOn AS DATE) AS [SSUpdatedDate]

			, GETDATE() CreatedDate
			, GETDATE() UpdatedDate
			, 0 IsDeleted
			, NULL DeleteDate

			, CAST(NULL AS INT) [AccountId]
			, 0 AS IsBusiness

--			select top 100 *
			FROM Prodcopy.vw_Contact c
			WHERE c.ModifiedOn > DATEADD(DAY,-3,GETDATE())
		

		
	) z

)





GO
