



CREATE VIEW [dbo].[vGoalsUpload]
WITH SCHEMABINDING
--- This translates the uploaded file into a view for syncing with current iep database table ---
AS
SELECT
	[IEPID] = I.IEPID
	,[StudentID] = S.StudentID
	,[GoalName] = SUBSTRING(SGU.GoalName, 1, 39)
	,[GoalStartDate] = CAST(SGU.GoalStartDate AS DATE)
	,[GoalEndDate] = CAST(SGU.GoalEndDate AS DATE)
	,[Goal] = TRIM(SGU.Goal)
	,[GoalServiceAreaID] = IIF(GSA.ServiceArea IS NULL, 18, GSA.Id)
	,[IEPTrackingCode] = 'Created'
	,[IEPTrackingDate] = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
	,[IEPTrackingReason] = 'Goal Created'
	,[IEPIsCurrent] = 1
	,[PlannedGoalMinutes] =	CASE
								WHEN SGU.PlannedGoalMinutes IS NULL THEN 0
								WHEN SGU.PlannedGoalMinutes = '' THEN 0
								WHEN SGU.PlannedGoalMinutes = 0 THEN 0
								ELSE SGU.PlannedGoalMinutes
							END
	,[PlannedGoalHoursFreq] = 'Week'
	,[IsSync] = 1
	,[UserID] = SGU.UserID
FROM dbo.StudentGoalsUpload AS SGU
INNER JOIN dbo.Student AS S ON CONCAT(S.StudentNumber,S.StudentStateID) = CONCAT(SGU.StudentNumber,SGU.StudentStateID)
FULL OUTER JOIN dbo.IEP AS I ON I.StudentID = S.StudentID
FULL OUTER JOIN dbo.GoalServiceArea AS GSA ON GSA.ServiceArea = SGU.GoalServiceArea
WHERE I.IEPID IS NULL AND Goal IS NOT NULL;

GO

