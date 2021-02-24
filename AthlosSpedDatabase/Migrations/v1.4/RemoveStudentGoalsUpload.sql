SELECT * FROM vGoalsUpload;
SELECT * FROM vStudentsUpload;
SELECT * FROM StudentGoalsUpload;
GO

----- DROP PROC -----
DROP PROC pETLSyncStudentUpload;
DROP PROC pETLSyncGoalUpload;
GO

---- DROP VIEWS -----

DROP VIEW vGoalsUpload;
DROP VIEW vStudentsUpload;
GO 

----- DROP TABLE ------
DROP TABLE dbo.StudentGoalsUpload;
GO