
CREATE PROCEDURE [dbo].[pAtwaterParentContactGoal]
AS
------ This procedure creates a goal named parent contact for each new student at Atwater Elementary School District

				-- 1) For UPDATE: Change the IsCurrent on any updated parent contact goal records
				WITH UpdateParentContactGoals 
					AS(
						SELECT IEPID, I.StudentID, IEPGoal, GoalServiceAreaID
							FROM IEP AS I
							INNER JOIN Student AS S
							ON S.StudentID = I.StudentID
							WHERE I.IEPName = 'Parent Contact' AND I.IEPIsCurrent = 0 AND S.StudentIsCurrent = 1
					)
					UPDATE IEP
						SET IEPEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
							,IEPIsCurrent = 1
						WHERE IEPID IN (SELECT IEPID FROM UpdateParentContactGoals )
					;

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

