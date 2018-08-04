CREATE TABLE [dbo].[HeatMap_SeatCoordinates]
(
[Team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Row] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat] [int] NULL,
[SeatCenter_X] [int] NULL,
[SeatCenter_Y] [int] NULL,
[SectionRowSeat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamSectionRowSeat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
