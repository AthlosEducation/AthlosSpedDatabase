



CREATE VIEW [dbo].[vETLIEPs]
/* Author: Christian Macdonald
** Desc: Extracts and transforms IEP goal data from staging DB
** Change Log: When,Who,What
** 2020-09-01,Christian Macdonald,Created View
** 2020-12-02,Christian Macdonald, Added group by clause
*/
AS
	SELECT
		IEPID = IL.IEPID
		,StudentID = I.StudentID
		,IEPName = I.GoalName
		,IEPGoal = I.GoalStatement
		,IEPStartDate = CAST(I.GoalStartDate AS DATE)
		,IEPEndDate = CAST(I.GoalEndDate AS DATE)
		,IEPTrackingCode = 'Created'
		,IEPTrackingDate = CAST(I.GoalStartDate AS DATE)
		,IEPTrackingReason = 'Goal Created'
		,IEPIsCurrent = 1
		,PlannedGoalHours = 0
		,PlannedGoalHoursFreq = 'Week'
		,GoalServiceAreaID = I.GoalServiceAreaID
	FROM vStagingIEPs AS I
	LEFT OUTER JOIN dbo.IEP AS IL
	ON CONCAT(IL.StudentID,IL.IEPGoal) = CONCAT(I.StudentID,I.GoalStatement)
	WHERE (IL.IEPIsCurrent = 1 OR IEPID IS NULL OR IEPEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE) OR (IL.IEPIsCurrent = 0 AND IEPID IS NOT NULL))
	GROUP BY
		IL.IEPID
		,I.StudentID
		,I.GoalName
		,I.GoalStatement
		,I.GoalStartDate
		,I.GoalEndDate
		,I.GoalServiceAreaID;

GO

