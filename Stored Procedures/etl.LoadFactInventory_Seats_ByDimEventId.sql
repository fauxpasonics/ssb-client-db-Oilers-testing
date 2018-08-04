SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[LoadFactInventory_Seats_ByDimEventId] 
( 
	@DimEventId INT
) 
 
AS 
BEGIN 


DECLARE @SourceSystem NVARCHAR(50), @event_id INT, @manifest_id int, @DimArenaId INT, @DimSeasonId INT

	SELECT @SourceSystem = dEvent.ETL__SourceSystem
	, @event_id = dEvent.ETL__SSID_TM_event_id
	, @manifest_id = dEvent.TM_manifest_id
	, @DimArenaId = ISNULL(dArena.DimArenaId, -1), @DimSeasonId = ISNULL(dSeason.DimSeasonId, -1)
	
	FROM etl.vw_DimEvent dEvent
	INNER JOIN etl.vw_DimSeason dSeason ON dEvent.TM_season_id = dSeason.ETL__SSID_TM_season_Id AND dEvent.ETL__SourceSystem = dSeason.ETL__SourceSystem
	INNER JOIN etl.vw_DimArena dArena ON devent.TM_arena_id = dArena.ETL__SSID_TM_arena_id AND dEvent.ETL__SourceSystem = dArena.ETL__SourceSystem
	WHERE dEvent.DimEventId = @DimEventId

	INSERT INTO etl.vw_FactInventory 
	(
		ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate
		, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat
		, DimArenaId, DimSeasonId, DimEventId, DimSeatId, DimSeatStatusid
	)

	SELECT 
		@SourceSystem
		, SUSER_NAME() ETL__CreatedBy, GETUTCDATE() ETL__CreatedDate, GETUTCDATE() ETL__UpdatedDate
		, @event_id, dSeat.ETL__SSID_TM_section_id, dSeat.ETL__SSID_TM_row_id, dSeat.ETL__SSID_TM_seat
		, @DimArenaId, @DimSeasonId, @DimEventId, dSeat.DimSeatId
		, -1 DimSeatStatusid
	--SELECT COUNT(*)

	FROM etl.vw_DimSeat dSeat
	LEFT OUTER JOIN etl.vw_FactInventory fi ON fi.DimEventId = @manifest_id AND fi.DimSeatId = dSeat.DimSeatId

	WHERE 1=1
		AND dSeat.ETL__SSID_TM_manifest_id = @manifest_id			
		AND ISNULL(dSeat.Config_IsFactInventoryEligible,1) <> 0
		AND fi.FactInventoryId IS NULL
		--AND de.IsClosed = 0				
		
	ORDER BY
		dSeat.DimSeatId

END
GO
