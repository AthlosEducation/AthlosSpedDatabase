CREATE  
VIEW [dbo].[vStudents]
WITH SCHEMABINDING
AS
SELECT TOP 1000000000000000
	StudentKey
	,[StudentName] = StudentFirstName + ' ' + StudentLastName
	,StudentNumber
	,StudentStateID
	,StudentGradeLevel
	,DistrictID
	,SchoolID
	,[StudentIsCurrent] =	CASE
								WHEN StudentIsCurrent = 1 THEN 'Current'
								WHEN StudentIsCurrent = 0 THEN 'Archived'
							END
FROM dbo.Student
ORDER BY [StudentName] ASC;

GO

