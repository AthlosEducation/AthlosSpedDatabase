CREATE TABLE [dbo].[SchoolYears] (
    [SchoolYearID] INT           IDENTITY (1, 1) NOT NULL,
    [SchoolYear]   NVARCHAR (25) NOT NULL,
    CONSTRAINT [pkSchoolYearID] PRIMARY KEY CLUSTERED ([SchoolYearID] ASC),
    CONSTRAINT [ukSchoolYear] UNIQUE NONCLUSTERED ([SchoolYear] ASC)
);


GO

