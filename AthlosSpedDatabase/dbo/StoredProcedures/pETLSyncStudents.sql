


CREATE   PROCEDURE [dbo].[pETLSyncStudents]
(@DistrictID INT)
/* Author: Christian Macdonald
** Desc: Updates data in Students using the vETLStudents view
** Change Log: When,Who,What
** 2020-06-01,Christian Macdonald,Created Sproc.
*/
AS
	BEGIN
		DECLARE @RC INT = 0
			BEGIN TRY		
				-- ETL Processing Code --
				-- 1) For UPDATE: Change the EndDate and IsCurrent on any updated student records
				WITH ChangedStudentsOldRecord 
					AS(
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM vETLStudents
							WHERE StudentID IS NOT NULL -- only need to update students that already exist in prod db
						EXCEPT
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM Student
							WHERE StudentIsCurrent = 1 -- dont want to match on all fields for current students
					)
					UPDATE Student
						SET StudentEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
							,StudentIsCurrent = 0
						WHERE StudentID IN (SELECT StudentID FROM ChangedStudentsOldRecord)
					;

				-- 2)For INSERT: Insert the new record for the update student info (aka student already exists in prod db and new records needs to be added for school/district info)
				WITH ChangedStudentsNewRecord
					AS(
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM vETLStudents
							WHERE StudentID IS NOT NULL -- only need to update students that already exist in prod db
						EXCEPT
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM Student 
							WHERE StudentIsCurrent = 1 -- dont want to match on all fields for current students
					)
						INSERT INTO Student
							([StudentID],[StudentFirstName],[StudentLastName],[StudentNumber],[StudentStateID],[StudentGradeLevel],[DistrictID],[SchoolID],[StudentStartDate],[StudentEndDate],[StudentIsCurrent],[IEPSnapshotID])
						SELECT
							[StudentID]
							,[StudentFirstName]
							,[StudentLastName]
							,[StudentNumber]
							,[StudentStateID]
							,[StudentGradeLevel]
							,[DistrictID]
							,[SchoolID]
							,[StartDate] = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
							,[EndDate] = NULL
							,[IsCurrent] = 1
							,[IEPSnapshotID] = 0
						FROM vETLStudents
						WHERE StudentID IN (SELECT StudentID FROM ChangedStudentsNewRecord)
					;

				-- 3)For INSERT: Add new rows to the table
				WITH AddedStudents
					AS(
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM vETLStudents
							WHERE StudentID IS NULL
						--EXCEPT
						--SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							--FROM Student 
							--WHERE StudentIsCurrent = 1 -- Needed if the value is changed back to previous value
					)
						INSERT INTO Student
							([StudentFirstName],[StudentLastName],[StudentNumber],[StudentStateID],[StudentGradeLevel],[DistrictID],[SchoolID],[StudentStartDate],[StudentEndDate],[StudentIsCurrent],[IEPSnapshotID])
						SELECT
							[StudentFirstName]
							,[StudentLastName]
							,[StudentNumber]
							,[StudentStateID]
							,[StudentGradeLevel]
							,[DistrictID]
							,[SchoolID]
							,[StartDate] = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
							,[EndDate] = NULL
							,[IsCurrent] = 1
							,[IEPSnapshotID] = 0
						FROM vETLStudents
						WHERE CONCAT(StudentNumber,SchoolID) IN (SELECT CONCAT(StudentNumber,SchoolID) FROM AddedStudents) -- unique list of students to insert (student numbers could be same across charter network districts)
					;

				-- 4) For DELETE: Mark student iscurrent = 0 and do not update only when the district ID matches that of the paratmeter given in the azure data factory paramater
				DECLARE @retval INT 
				SELECT @retval = COUNT(*) FROM vETLStudents;

				IF (@retval > 0) -- first need to make sure that the vETLStudents table is actually populated to avoid archiving a bunch of students
				BEGIN
					WITH DeletedStudents 
						AS(
							SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
								FROM Student
								WHERE StudentIsCurrent = 1 -- We do not care about row already marked zero
								AND DistrictID = @DistrictID
 							EXCEPT           		
							SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
								FROM vETLStudents
   						)
							UPDATE Student
								SET StudentEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
									,StudentIsCurrent = 0
								WHERE CONCAT(StudentNumber,SchoolID) IN (SELECT CONCAT(StudentNumber,SchoolID) FROM DeletedStudents) -- unique list of students to delete in case student number matches across district
						;
				END
				ELSE
				BEGIN
					INSERT INTO dbo.ErrorLog (ErrorDate, ErrorDescription, ErroredTask, DistrictID)
					VALUES (
						CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
						,'The view vETLStudents had a row count that is less than or equal to zero so the sync was ignored'
						,'pETLSyncStudents'
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
						,'pETLSyncStudents'
						,@DistrictID
						)
					;
				END CATCH
		RETURN @RC;
	END

GO

