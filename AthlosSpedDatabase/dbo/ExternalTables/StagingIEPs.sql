CREATE EXTERNAL TABLE [dbo].[StagingIEPs] (
    [StudentStateID] NVARCHAR (25) NULL,
    [GoalName] NVARCHAR (200) NULL,
    [GoalStatement] NVARCHAR (MAX) NULL,
    [GoalStartDate] NVARCHAR (25) NULL,
    [GoalEndDate] NVARCHAR (25) NULL,
    [GoalServiceAreaID] INT NOT NULL,
    [StudentNumber] NVARCHAR (25) NULL
)
    WITH (
    DATA_SOURCE = [StagingDatabase]
    );


GO

