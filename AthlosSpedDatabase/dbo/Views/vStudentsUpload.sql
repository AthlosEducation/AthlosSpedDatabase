

CREATE VIEW [dbo].[vStudentsUpload]
WITH SCHEMABINDING
--- This translates the uploaded file into a view for syncing with current students database table ---
AS
SELECT
	S.StudentID
	,SGU.StudentFirstName
	,SGU.StudentLastName
	,SGU.StudentNumber
	,SGU.StudentStateID
	,[StudentGradeLevel] = SUBSTRING(SGU.StudentGradeLevel, 1, 2)
	,U.DistrictID
	,U.SchoolID
	,[StudentStartDate] = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
	,[StudentEndDate] = NULL
	,[StudentIsCurrent] = 1
	,[IEPSnapshotID] = 0
	,U.UserID
FROM dbo.StudentGoalsUpload AS SGU
INNER JOIN dbo.Users AS U ON U.UserID = SGU.UserID
FULL OUTER JOIN dbo.Student AS S ON CONCAT(S.StudentNumber,S.StudentStateID) = CONCAT(SGU.StudentNumber,SGU.StudentStateID)
GROUP BY
	SGU.StudentFirstName
	,SGU.StudentLastName
	,SGU.StudentNumber
	,SGU.StudentStateID
	,SGU.StudentGradeLevel
	,U.DistrictID
	,U.SchoolID
	,U.UserID
	,S.StudentID
HAVING SGU.StudentFirstName IS NOT NULL AND SGU.StudentFirstName <> '';

GO

