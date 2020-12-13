CREATE  
VIEW vStudentIDLinker
AS
SELECT
	[ProdDBStudentSelectorID]
	,[StagDBStudentSelectorID]
	,[StudentID]
FROM vProdDBStudentSelector AS P
FULL OUTER JOIN vStagingStudents AS S
ON P.ProdDBStudentSelectorID = S.StagDBStudentSelectorID;

GO

