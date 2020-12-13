CREATE 
VIEW vLatestStudentKeyByStudentID
AS 
SELECT 
	StudentID
	,[MaxStudentKey] = Max(StudentKey)
FROM Student
GROUP BY StudentID;

GO

