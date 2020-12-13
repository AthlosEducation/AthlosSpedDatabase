





CREATE PROCEDURE [dbo].[pETLSyncStudentUpload]
(@UserID INT)
/* Author: Christian Macdonald
** Desc: Updates data in Students from the individual user process using the vStudentsUpload view
** Change Log: When,Who,What
** 2020-11-13,Christian Macdonald,Created Sproc.
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
							FROM vStudentsUpload
							WHERE StudentID IS NOT NULL AND UserID = @UserID -- only need to update students that already exist in prod db
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
							FROM vStudentsUpload
							WHERE StudentID IS NOT NULL AND UserID = @UserID -- only need to update students that already exist in prod db
						EXCEPT
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM Student 
							WHERE StudentIsCurrent = 1 -- dont want to match on all fields for current students
					)
						INSERT INTO Student
							([StudentID],[StudentFirstName],[StudentLastName],[StudentNumber],[StudentStateID],[StudentGradeLevel],[DistrictID],[SchoolID],[StudentStartDate],[StudentIsCurrent],[IEPSnapshotID])
						SELECT
							[StudentID]
							,[StudentFirstName]
							,[StudentLastName]
							,[StudentNumber]
							,[StudentStateID]
							,[StudentGradeLevel]
							,[DistrictID]
							,[SchoolID]
							,[StudentStartDate]
							,[StudentIsCurrent]
							,[IEPSnapshotID]
						FROM vStudentsUpload
						WHERE StudentID IN (SELECT StudentID FROM ChangedStudentsNewRecord)
					;

				-- 3)For INSERT: Add new rows to the table
				WITH AddedStudents
					AS(
						SELECT StudentID, StudentFirstName, StudentLastName, StudentNumber, StudentStateID, StudentGradeLevel, DistrictID, SchoolID
							FROM vStudentsUpload
							WHERE StudentID IS NULL AND UserID = @UserID
					)
						INSERT INTO Student
							([StudentFirstName],[StudentLastName],[StudentNumber],[StudentStateID],[StudentGradeLevel],[DistrictID],[SchoolID],[StudentStartDate],[StudentIsCurrent],[IEPSnapshotID])
						SELECT
							[StudentFirstName]
							,[StudentLastName]
							,[StudentNumber]
							,[StudentStateID]
							,[StudentGradeLevel]
							,[DistrictID]
							,[SchoolID]
							,[StudentStartDate]
							,[StudentIsCurrent]
							,[IEPSnapshotID]
						FROM vStudentsUpload
						WHERE CONCAT(StudentNumber,SchoolID) IN (SELECT CONCAT(StudentNumber,SchoolID) FROM AddedStudents) -- unique list of students to insert (student numbers could be same across charter network districts)
					;

				-- 4)For INSERT: Add new rows to the student user (caseloads) table
						INSERT INTO dbo.StudentUser ([UserID], [StudentKey])
						SELECT
							[UserID]
							,[StudentKey]
						FROM Student AS S
						INNER JOIN vStudentsUpload AS SU ON CONCAT(SU.StudentNumber,SU.StudentStateID) = CONCAT(S.StudentNumber,S.StudentStateID)
						WHERE StudentKey NOT IN (SELECT StudentKey FROM StudentUser WHERE UserID = @UserID)
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

