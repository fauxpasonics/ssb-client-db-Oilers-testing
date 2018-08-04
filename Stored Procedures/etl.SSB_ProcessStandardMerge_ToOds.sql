SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[SSB_ProcessStandardMerge_ToOds]
(
	@Target VARCHAR(256),
	@Source VARCHAR(256),
	@BusinessKey VARCHAR(256),
	@OrderBy VARCHAR(256)		= NULL,
	@EnableSoftDelete char(5)	= 'false',
	@Options NVARCHAR(MAX)		= NULL
)

AS
BEGIN

/**************************************Comments***************************************
**************************************************************************************
Mod #:		1
Name:		ssbcloud\zfrick
Date:		04/17/2016
Comments:	Dynamically generates and executes standard SSB Merge from source table to destination table.

Mod #:		2
Name:		ssbcloud\dhorstman
Date:		02/23/2017
Comments:	Added @OrderBy parameter and derived table with partition function to work around duplicates.

Mod #:		3
Name:		ssbcloud\dhorstman
Date:		03/09/2017
Comments:	Added @EnableSoftDelete parameter to indicate whether soft deletes should be performed.

*************************************************************************************/
--	*****	For testing purposes	*****
--	DECLARE	@Target varchar(256)		= 'ods.BB_Address',
--			@Source varchar(256)		= 'stg.BB_Address',
--			@BusinessKey varchar(256)	= 'ID',
--			@OrderBy varchar(256)		= 'ETL_ID',
--			@EnableSoftDelete char(5)	= 'false',
--			@Options nvarchar(MAX)		= NULL


DECLARE	@SQL VARCHAR(MAX),
		@SQL2 VARCHAR(MAX),
		@SQL3 VARCHAR(MAX)

DECLARE	@ColString VARCHAR(MAX)
SET
	 @ColString = 
	 ( SELECT STUFF ((
                    SELECT ', [' + name + ']'
                    FROM sys.columns
                    WHERE object_id = OBJECT_ID(@Source) and name not in ('ETL_ID','ETL_CreatedDate')		
					ORDER BY column_id		
                    FOR XML PATH('')), 1, 1, '') 
	 )


/*****
	set list of excluded columns to be omitted from hashkey build.  Columns beginning with ETL_ will automatically be excluded,
	while the second paramter in the call to etl.SSB_ExcludedHashColumns is a list of any additional columns to be excluded.
*****/
DECLARE @ExcludedHashColumns VARCHAR(MAX);
DECLARE	@ExcludedHashColumnsTbl TABLE (ExcludedColumns VARCHAR(MAX));
INSERT @ExcludedHashColumnsTbl (ExcludedColumns)
	EXEC etl.SSB_ExcludedHashColumns @Source,NULL;
SET @ExcludedHashColumns = (SELECT TOP 1 ExcludedColumns FROM @ExcludedHashColumnsTbl); 


--	build hashkey for comparison in merge
DECLARE @HashSyntax VARCHAR(MAX);
DECLARE	@HashTbl TABLE (HashSyntax VARCHAR(MAX));
INSERT @HashTbl (HashSyntax)
	EXEC etl.SSB_MergeHashFieldSyntax @Source, @ExcludedHashColumns;
SET @HashSyntax = (SELECT TOP 1 HashSyntax FROM @HashTbl);


DECLARE	@JoinString varchar(MAX)
SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			select 'myTarget.' + a.Item + ' = mySource.' + a.Item as match
			from dbo.Split (@BusinessKey, ',') a 
		)	x	
        FOR XML PATH('')), 1, 5, '')
	)

DECLARE	@SqlStringMax AS VARCHAR(MAX) = ''
DECLARE	@SchemaName  AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,1)
DECLARE	@Table AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,2)
DECLARE @OrderByString NVARCHAR(255) = (SELECT CASE WHEN ISNULL(@OrderBy,'') = '' THEN 'ETL_ID' ELSE @OrderBy END);
	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(mySource.' + COLUMN_NAME + ','''') <> ' + 'ISNULL(myTarget.' + COLUMN_NAME + ','''') '
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @Table
	AND ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0
	AND COLUMN_NAME NOT IN ('ETL_ID','ETL_CreatedDate')

	
SELECT @SQL = 
'
DECLARE @RunTime DATETIME = GETDATE()

DECLARE @BatchId uniqueidentifier = newid();
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = ''ProcessStandardMerge_' + @Target + '''
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0'';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting(''ClientName''), DB_NAME()));
DECLARE @SoftDelete bit = (SELECT CASE WHEN ''' + @EnableSoftDelete + ''' = ''true'' THEN 1 ELSE 0 END);

/*Load Options into a temp table*/
--SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, ''='', '';'')
--DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableDelete''),''true'')

BEGIN TRY 


SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
, ' + @ColString + '
INTO #SrcData
FROM (
	SELECT ' + @ColString + ',
	ROW_NUMBER() OVER (Partition By ' + @BusinessKey + ' Order By ' + @OrderByString + ') as RowNum
	FROM ' + @Source + ') x
WHERE RowNum = 1;


CREATE NONCLUSTERED INDEX IDX_BusinessKey_HashKey ON #SrcData (' + @BusinessKey + ',ETL_DeltaHashKey);

UPDATE #SrcData
SET ETL_DeltaHashKey = ' + @HashSyntax + '


--		soft delete BEFORE removing existing, unchanged records from #SrcData 
IF @SoftDelete = 1
BEGIN
	UPDATE myTarget
	SET myTarget.ETL_IsDeleted = 1,
		myTarget.ETL_DeletedDate = @RunTime
	FROM ' + @Target + ' myTarget
	LEFT JOIN #SrcData mySource
		ON ' + @JoinString + '
	WHERE mySource.ETL_DeltaHashKey IS NULL
END


DELETE mySource
FROM #SrcData mySource
	JOIN ' + @Target + ' myTarget
	ON ' + @JoinString + ' and mySource.ETL_DeltaHashKey = myTarget.ETL_DeltaHashKey;
	

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (' + @BusinessKey + ')
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

';

-------------------------------------------------------------------------------------------------

SELECT @SQL2 = 
'

MERGE ' + @Target + ' AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON ' + @JoinString + '

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
      ' +
          STUFF ((
                    SELECT ',myTarget.[' + name + '] = mySource.[' + name + ']' + CHAR(10) + '     '
                           
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
						AND name NOT IN ('ETL_ID','ETL_CreatedDate','ETL_UpdatedDate','ETL_IsDeleted','ETL_DeletedDate')
						ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '')  +

',myTarget.ETL_UpdatedDate = @RunTime
	 ,myTarget.ETL_IsDeleted = 0
	 ,myTarget.ETL_DeletedDate = NULL


';

-------------------------------------------------------------------------------------------------

SELECT @SQL3 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (' + 
          STUFF ((
                    SELECT ',[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
						AND name NOT IN ('ETL_ID','ETL_CreatedDate','ETL_UpdatedDate','ETL_IsDeleted','ETL_DeletedDate')
					ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '') +
	',[ETL_CreatedDate]
	 ,[ETL_UpdatedDate]
	 ,[ETL_IsDeleted]
	 ,[ETL_DeletedDate]
	 )

VALUES
     (' +
          STUFF ((
                    SELECT ',mySource.[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
						AND name NOT IN ('ETL_ID','ETL_CreatedDate','ETL_UpdatedDate','ETL_IsDeleted','ETL_DeletedDate')
					ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '') + 

',@RunTime
	 ,@RunTime
	 ,0
	 ,NULL	
	)
;



END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH



'

PRINT @SQL
PRINT @SQL2 
PRINT @SQL3

DECLARE @Full_SQL NVARCHAR(MAX) = @SQL + @SQL2 + @SQL3;


EXEC (@Full_SQL)


ExitSproc:

END







GO
