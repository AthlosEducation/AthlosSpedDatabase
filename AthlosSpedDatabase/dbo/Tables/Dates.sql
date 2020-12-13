CREATE TABLE [dbo].[Dates] (
    [DateKey]      INT           NOT NULL,
    [FullDate]     DATETIME      NOT NULL,
    [FullDateName] NVARCHAR (50) NULL,
    [MonthID]      INT           NOT NULL,
    [MonthName]    NVARCHAR (50) NOT NULL,
    [YearID]       INT           NOT NULL,
    [YearName]     NVARCHAR (50) NOT NULL,
    [WeekNumber]   NVARCHAR (25) NOT NULL
);


GO

CREATE NONCLUSTERED INDEX [ixDates]
    ON [dbo].[Dates]([FullDate] ASC);


GO

