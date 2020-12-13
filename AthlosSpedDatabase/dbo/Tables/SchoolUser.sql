CREATE TABLE [dbo].[SchoolUser] (
    [SchoolUserID] INT IDENTITY (1, 1) NOT NULL,
    [UserID]       INT NOT NULL,
    [SchoolID]     INT NOT NULL,
    [DistrictID]   INT NOT NULL,
    CONSTRAINT [pkSchoolUserID] PRIMARY KEY CLUSTERED ([SchoolUserID] ASC)
);


GO

