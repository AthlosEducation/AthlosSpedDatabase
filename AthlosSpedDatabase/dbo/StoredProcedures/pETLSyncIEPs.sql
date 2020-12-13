


CREATE PROCEDURE [dbo].[pETLSyncIEPs]
(@DistrictID INT)
/* Author: Christian Macdonald
** Desc: Updates data in IEPs using the vETLIEPs view
** Change Log: When,Who,What
** 2020-09-01,Christian Macdonald,Created Sproc.
** 2020-12-03,Christian Macdonald,Removed unecessary IEP index and fixed grouping.
*/
AS
	BEGIN
		DECLARE @RC INT = 0
			BEGIN TRY		
				-- ETL Processing Code --
				-- 1) For UPDATE: Change the EndDate and IsCurrent on any updated goal records
				WITH ChangedGoalsOldRecord 
					AS(
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM dbo.vETLIEPs
							WHERE IEPID IS NOT NULL -- only need to update goals that already exist in prod db
						EXCEPT
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM dbo.IEP
							WHERE IEPIsCurrent = 1 AND IsSync = 1 -- dont want to match on all fields for current goals
					)
					UPDATE dbo.IEP
						SET IEPEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
							,IEPIsCurrent = 0
						WHERE IEPID IN (SELECT IEPID FROM ChangedGoalsOldRecord)
					;

				-- 2)For INSERT: Insert the new record for the updated goal info (aka goal already exists in prod db and new records needs to be added for changed info)
				WITH ChangedGoalsNewRecord
					AS(
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM dbo.vETLIEPs
							WHERE IEPID IS NOT NULL -- only need to update goals that already exist in prod db
						EXCEPT
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM dbo.IEP
							WHERE IEPIsCurrent = 1 AND IsSync = 1 -- dont want to match on all fields for current goals
					)
						INSERT INTO dbo.IEP
							([IEPID],[StudentID],[IEPName],[IEPGoal],[IEPStartDate],[IEPEndDate],[IEPTrackingCode],[IEPTrackingDate],[IEPTrackingReason],[IEPIsCurrent],[PlannedGoalHours],[PlannedGoalHoursFreq],[GoalServiceAreaID],[IsSync])
						SELECT 
							[IEPID]
							,[StudentID]
							,[IEPName]
							,[IEPGoal]
							,[IEPStartDate]
							,[IEPEndDate]
							,[IEPTrackingCode]
							,[IEPTrackingDate]
							,[IEPTrackingReason]
							,[IEPIsCurrent] = 1
							,[PlannedGoalHours]
							,[PlannedGoalHoursFreq]
							,[GoalServiceAreaID]
							,[IsSync] = 1
						FROM dbo.vETLIEPs
						WHERE IEPID IN (SELECT IEPID FROM ChangedGoalsNewRecord)
					;

				-- 3)For INSERT: Add new rows to the table
				WITH AddedGoals
					AS(
						SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
							FROM dbo.vETLIEPs
							WHERE IEPID IS NULL
					)
						INSERT INTO dbo.IEP
							([IEPID],[StudentID],[IEPName],[IEPGoal],[IEPStartDate],[IEPEndDate],[IEPTrackingCode],[IEPTrackingDate],[IEPTrackingReason],[IEPIsCurrent],[PlannedGoalHours],[PlannedGoalHoursFreq],[GoalServiceAreaID],[IsSync])
						SELECT
							[IEPID] = 0
							,[StudentID]
							,[IEPName]
							,[IEPGoal]
							,[IEPStartDate]
							,[IEPEndDate]
							,[IEPTrackingCode]
							,[IEPTrackingDate]
							,[IEPTrackingReason]
							,[IEPIsCurrent]
							,[PlannedGoalHours]
							,[PlannedGoalHoursFreq]
							,[GoalServiceAreaID]
							,[IsSync] = 1
						FROM dbo.vETLIEPs
						WHERE CONCAT(StudentID,IEPGoal) IN (SELECT CONCAT(StudentID,IEPGoal) FROM AddedGoals) -- unique list of goals to insert (goal detail is the lowest level of grain)
					;

				-- 4) For DELETE: Mark goal iscurrent = 0 and do not update only when the district ID matches that of the paratmeter given in the azure data factory paramater
				DECLARE @retval INT 
				SELECT @retval = COUNT(*) FROM vETLIEPs;

				IF (@retval > 0) -- first need to make sure that the vETLIEPs table is actually populated to avoid archiving a bunch of goals
				BEGIN
					WITH DeletedGoals 
						AS(
							SELECT IEPID, I.StudentID, IEPGoal, GoalServiceAreaID
								FROM dbo.IEP AS I
								INNER JOIN dbo.Student AS S
								ON I.StudentID = S.StudentID
								WHERE IEPIsCurrent = 1 AND IsSync = 1 -- We do not care about row already marked zero
								AND S.DistrictID = @DistrictID
 							EXCEPT           		
							SELECT IEPID, StudentID, IEPGoal, GoalServiceAreaID
								FROM dbo.vETLIEPs
   						)
							UPDATE dbo.IEP
								SET IEPIsCurrent = 0
								WHERE IEPID IN (SELECT IEPID FROM DeletedGoals) -- unique list of goals to delete
						;
				END
				ELSE
				BEGIN
					INSERT INTO dbo.ErrorLog (ErrorDate, ErrorDescription, ErroredTask, DistrictID)
					VALUES (
						CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
						,'The view vETLIEPs had a row count that is less than or equal to zero so the sync was ignored'
						,'pETLSyncIEPs'
						,@DistrictID
						)
					;	
				END

				SET @RC = +1
				END TRY
				BEGIN CATCH
					PRINT Error_Message()
					SET @RC = -1
					INSERT INTO dbo.ErrorLog (ErrorDate, ErrorDescription, ErroredTask, DistrictID)
					VALUES (
						CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
						,Error_Message()
						,'pETLSyncIEPs'
						,@DistrictID
						)
					;
				END CATCH
		RETURN @RC;
	END

GO

