CREATE TABLE [dbo].[StudentGoalsUpload] (
    [StudentGoalsUploadID] INT            IDENTITY (1, 1) NOT NULL,
    [UserID]               INT            NOT NULL,
    [StudentFirstName]     NVARCHAR (50)  NULL,
    [StudentLastName]      NVARCHAR (50)  NULL,
    [StudentNumber]        NVARCHAR (25)  NULL,
    [StudentStateID]       NVARCHAR (25)  NULL,
    [StudentGradeLevel]    NVARCHAR (25)  NULL,
    [GoalServiceArea]      NVARCHAR (100) NULL,
    [GoalName]             NVARCHAR (100) NULL,
    [GoalStartDate]        NVARCHAR (50)  NULL,
    [GoalEndDate]          NVARCHAR (50)  NULL,
    [Goal]                 NVARCHAR (MAX) NULL,
    [PlannedGoalMinutes]   INT            NULL
);


GO

