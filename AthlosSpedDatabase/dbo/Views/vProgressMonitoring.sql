CREATE  
VIEW [dbo].[vProgressMonitoring]
WITH SCHEMABINDING
AS
SELECT
	[ProgressMonitoringID] = P.ProgressMonitoringID
	,[DistrictID] = P.DistrictID
	,[SchoolID] = P.SchoolID
	,[UserID] = P.UserID
	,[Username] = U.UserName
	,[StudentKey] = P.StudentKey
	,[IEPKey] = P.IEPKey
	,[SchoolYearID] = P.SchoolYearID
	,[Date] = P.Date
	,[Photos] =	IIF(P.ProgressFileUpload IS NOT NULL,1,0)
	--,[ProgressMeasurementPeriod] = P.ProgressMeasurementPeriod
	,[GoalProgress] = P.GoalProgress
	--,[ProgressTrialNumber] = P.ProgressTrialNumber
	,[Absences] = IIF(P.WasAbsent = 0,'Student was present','Student was absent')
	,[GoalsMet] = IIF(P.GoalProgress = 'Goal Met', 1, 0)
	,[GoalsNotOnTrack] =	CASE
								WHEN P.GoalProgress = 'Limited Progress' THEN 1
								WHEN P.GoalProgress = 'No Progress Made' THEN 1
								ELSE 0
							END
	,[ProgressScore] =		CASE
								WHEN P.GoalProgress = 'No Progress Made' THEN 1
								WHEN P.GoalProgress = 'Limited Progress' THEN 2
								WHEN P.GoalProgress = 'On Track' THEN 3
								WHEN P.GoalProgress = 'Goal Met' THEN 4
								ELSE 0
							END
	,[ProgressDetailedNotes] = 'Assessment Used: ' + P.ProgressAssessment + '. Assessment Score: ' + P.ProgressScore + '. Progress Notes: ' + P.ProgressNotes
FROM dbo.ProgressMonitoring AS P
INNER JOIN dbo.Users AS U
ON U.UserID = P.UserID;

GO

