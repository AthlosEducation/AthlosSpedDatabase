
ALTER PROCEDURE [dbo].[pAtwaterParentContactGoal]
AS
------ This procedure creates a goal named parent contact for each new student at Atwater Elementary School District

				-- 2) For ADDING: Add new parent contact goals to the prod db for Atwater Elementary
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
						,IsSync
						)
					SELECT
						IEPID = NEXT VALUE FOR seq_IEPID
						,S.StudentID
						,'Parent Contact'
						,'This is a generic goal to capture all parent contacts for this student'
						,'2020-08-01'
						,'2021-07-31'
						,'Created'
						,'2020-08-01'
						,'Goal Created'
						,1
						,0
						,'Week'
						,18
						,0
					FROM Student AS S
					WHERE S.DistrictID = 11 AND S.StudentID NOT IN (SELECT StudentID FROM IEP WHERE IEPIsCurrent = 1 AND IEPName = 'Parent Contact') AND S.StudentIsCurrent = 1;

GO

