CREATE TABLE [dbo].[DimDate]
(
[DimDateId] [int] NOT NULL,
[CalDate] [date] NOT NULL,
[CalDateFormat] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalDateLabel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalDateLabelLong] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalYear] [int] NULL,
[CalQuarterNumber] [int] NULL,
[MonthNumber] [int] NULL,
[WeekNumber] [int] NULL,
[DayOfYearNumber] [int] NULL,
[DayOfQuarterNumber] [int] NULL,
[DayOfMonthNumber] [int] NULL,
[DayOfWeekNumber] [int] NULL,
[DayOfWeek] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalQuarter] [int] NULL,
[CalMonth] [int] NULL,
[CalWeek] [int] NULL,
[CalMonthLabel] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalQuarterLabel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsWeekend] [bit] NULL,
[CalMonthLastDayFlag] [bit] NULL,
[IsHoliday] [bit] NULL,
[HolidayLabel] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FiscalYear] [int] NULL,
[FiscalYearLabel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FiscalQuarter] [int] NULL,
[FiscalQuarterNumber] [int] NULL,
[FiscalQuarterLabel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FiscalMonth] [int] NULL,
[FiscalMonthNumber] [int] NULL,
[FiscalWeek] [int] NULL,
[FiscalDayInYear] [int] NULL,
[FiscalDayInQuarter] [int] NULL,
[UTCOffset] [int] NULL
)
GO
ALTER TABLE [dbo].[DimDate] ADD CONSTRAINT [PK_DimDate_1] PRIMARY KEY CLUSTERED  ([DimDateId])
GO
CREATE NONCLUSTERED INDEX [IDX_CalDate] ON [dbo].[DimDate] ([CalDate])
GO
