--********************************************************************--
-- A) Create views to align org names with sped logs school and district id's
--********************************************************************--

CREATE  
VIEW vMatchSchoolID
AS
SELECT 
	O.name
	,S.SchoolName
	,S.SchoolID
	,S.DistrictID
FROM Orgs AS O 
INNER JOIN School AS S
ON O.name = S.SchoolName
WHERE O.type = 'school';

GO

