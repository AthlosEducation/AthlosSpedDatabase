

CREATE PROCEDURE [dbo].[pETLSyncGoalUpload]
(@UserID INT)
/* Author: Christian Macdonald
** Desc: Updates data in IEP from the individual user process using the vGoalsUpload view
** Change Log: When,Who,What
** 2020-09-01,Christian Macdonald,Created Sproc.
*/
AS
	BEGIN
		DECLARE @RC INT = 0
			BEGIN TRY		
				-- ETL Processing Code --
				-- 1) For UPDATE: Change the EndDate and IsCurrent on any updated goal records
				WITH ChangedGoalsOldRecord 
					AS(
						SELECT IEPID, StudentID, Goal, GoalServiceAreaID
							FROM vGoalsUpload
							WHERE IEPID IS NOT NULL AND UserID = @UserID -- only need to update goals that already exist in prod db
						EXCEPT
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM IEP
							WHERE IEPIsCurrent = 1 -- dont want to match on all fields for current goals
					)
					UPDATE IEP
						SET IEPEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
							,IEPIsCurrent = 0
						WHERE IEPID IN (SELECT IEPID FROM ChangedGoalsOldRecord)
					;

				-- 2)For INSERT: Insert the new record for the updated goal info (aka goal already exists in prod db and new records needs to be added for changed info)
				WITH ChangedGoalsNewRecord
					AS(
						SELECT IEPID, StudentID, Goal, GoalServiceAreaID
							FROM vGoalsUpload
							WHERE IEPID IS NOT NULL AND UserID = @UserID -- only need to update goals that already exist in prod db
						EXCEPT
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM IEP
							WHERE IEPIsCurrent = 1 -- dont want to match on all fields for current goals
					)
						INSERT INTO IEP
							([IEPID],[StudentID],[IEPName],[IEPGoal],[IEPStartDate],[IEPEndDate],[IEPTrackingCode],[IEPTrackingDate],[IEPTrackingReason],[IEPIsCurrent],[PlannedGoalHours],[PlannedGoalHoursFreq],[GoalServiceAreaID],[IsSync])
						SELECT
							[IEPID]
							,[StudentID]
							,[GoalName]
							,[Goal]
							,[GoalStartDate]
							,[GoalEndDate]
							,[IEPTrackingCode]
							,[IEPTrackingDate]
							,[IEPTrackingReason]
							,[IEPIsCurrent]
							,[PlannedGoalMinutes]
							,[PlannedGoalHoursFreq]
							,[GoalServiceAreaID]
							,[IsSync]
						FROM vGoalsUpload
						WHERE IEPID IN (SELECT IEPID FROM ChangedGoalsNewRecord)
					;

				-- 3)For INSERT: Add new rows to the table
				WITH AddedGoals
					AS(
						SELECT IEPID, StudentID, Goal, GoalServiceAreaID
							FROM vGoalsUpload
							WHERE IEPID IS NULL AND UserID = @UserID
					)
						INSERT INTO IEP
							([IEPID],[StudentID],[IEPName],[IEPGoal],[IEPStartDate],[IEPEndDate],[IEPTrackingCode],[IEPTrackingDate],[IEPTrackingReason],[IEPIsCurrent],[PlannedGoalHours],[PlannedGoalHoursFreq],[GoalServiceAreaID],[IsSync])
						SELECT
							[IEPID] = 0
							,[StudentID]
							,[GoalName]
							,[Goal]
							,[GoalStartDate]
							,[GoalEndDate]
							,[IEPTrackingCode]
							,[IEPTrackingDate]
							,[IEPTrackingReason]
							,[IEPIsCurrent]
							,[PlannedGoalMinutes]
							,[PlannedGoalHoursFreq]
							,[GoalServiceAreaID]
							,[IsSync]
						FROM vGoalsUpload
						WHERE CONCAT(StudentID,Goal) IN (SELECT CONCAT(StudentID,Goal) FROM AddedGoals) -- unique list of goals to insert (goal detail is the lowest level of grain)
					;

				SET @RC = +1
				END TRY
				BEGIN CATCH
					PRINT Error_Message()
					SET @RC = -1
				END CATCH
		RETURN @RC;
	END

GO

