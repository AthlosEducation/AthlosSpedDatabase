
CREATE PROCEDURE [dbo].[pRuidosoPlaceholderGoal]
AS
------ This procedure creates a goal named students goal for each new student at Ruidoso Municipal School District

	INSERT INTO dbo.IEP (
		IEPID
		,StudentID
		,IEPName
		,IEPGoal
		,IEPStartDate
		,IEPEndDate
		,IEPTrackingCode
		,IEPTrackingDate
		,IEPTrackingReason
		,IEPIsCurrent
		,PlannedGoalHours
		,PlannedGoalHoursFreq
		,GoalServiceAreaID
		)
	SELECT
		IEPID = NEXT VALUE FOR seq_IEPID
		,S.StudentID
		,'Student Goal'
		,'This is a generic goal to capture all services provided for this student'
		,'2020-08-01'
		,'2021-07-31'
		,'Created'
		,'2020-08-01'
		,'Goal Created'
		,1
		,0
		,'Week'
		,18
	FROM Student AS S
	WHERE S.DistrictID = 13 AND S.StudentID NOT IN (SELECT StudentID FROM IEP);

GO

