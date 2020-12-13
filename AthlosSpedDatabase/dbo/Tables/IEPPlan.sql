CREATE TABLE [dbo].[IEPPlan] (
    [IEPKey]           INT             NULL,
    [WeekNumber]       INT             NULL,
    [PlannedGoalHours] DECIMAL (18, 2) NULL
);


GO

CREATE NONCLUSTERED INDEX [ixIEPPlanWeekNum]
    ON [dbo].[IEPPlan]([WeekNumber] ASC)
    INCLUDE([IEPKey], [PlannedGoalHours]);


GO

CREATE CLUSTERED INDEX [ixIEPPlanClustered]
    ON [dbo].[IEPPlan]([IEPKey] ASC);


GO

