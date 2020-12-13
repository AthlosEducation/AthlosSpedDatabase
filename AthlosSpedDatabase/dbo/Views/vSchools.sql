CREATE  
VIEW vSchools
WITH SCHEMABINDING
AS
SELECT
	SchoolID
	,SchoolName
FROM dbo.School;

GO

