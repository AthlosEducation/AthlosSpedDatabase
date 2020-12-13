
CREATE PROCEDURE [dbo].[CheckDuplicateGoals]
AS
WITH CTE AS (
    SELECT 
		IEPKey
		,IEPID
		,StudentID
		,IEPName
		,IEPGoal
		,IEPStartDate
		,IEPEndDate
		,IEPTrackingDate
		,IEPIsCurrent
		,GoalServiceAreaID
        ,ROW_NUMBER() OVER (
            PARTITION BY 
				StudentID
				,IEPName
				,IEPGoal
				,IEPStartDate
				,IEPEndDate
				,IEPTrackingDate
				,IEPIsCurrent
				,GoalServiceAreaID
            ORDER BY 
				StudentID
				,IEPName
				,IEPGoal
				,IEPStartDate
				,IEPEndDate
				,IEPTrackingDate
				,IEPIsCurrent
				,GoalServiceAreaID
        ) row_num
     FROM 
        dbo.IEP
)
DELETE FROM CTE
WHERE row_num > 1 AND IEPIsCurrent = 1;

GO

