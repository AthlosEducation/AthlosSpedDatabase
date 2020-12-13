
CREATE  
VIEW vMatchDistrictID
AS
SELECT 
	O.name
	,D.DistrictName
	,D.DistrictID
FROM Orgs AS O 
INNER JOIN District AS D
ON O.name = D.DistrictName
WHERE O.type = 'district';

GO

