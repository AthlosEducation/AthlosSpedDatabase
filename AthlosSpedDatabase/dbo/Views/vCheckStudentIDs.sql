CREATE   VIEW vCheckStudentIDs
AS
SELECT TOP 100000000 * FROM Student
WHERE StudentID IN (
					SELECT StudentID FROM Student
					GROUP BY StudentID
					HAVING COUNT(StudentID)>1
					)
ORDER BY StudentID;

GO

