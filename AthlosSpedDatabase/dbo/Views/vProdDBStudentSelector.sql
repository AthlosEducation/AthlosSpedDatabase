

CREATE  
VIEW [dbo].[vProdDBStudentSelector]
AS
SELECT
	[ProdDBStudentSelectorID] = S.StudentFirstName + S.StudentLastName + S.StudentNumber
	,[StudentID] = S.StudentID
FROM Student AS S
WHERE (S.StudentIsCurrent = 1 OR S.StudentEndDate = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE));

GO

