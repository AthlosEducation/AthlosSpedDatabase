CREATE TABLE [dbo].[GoalServiceArea] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Category]    NVARCHAR (225) NULL,
    [ServiceArea] NVARCHAR (225) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

