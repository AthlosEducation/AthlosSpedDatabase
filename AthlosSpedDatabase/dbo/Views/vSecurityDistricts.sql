CREATE   
VIEW vSecurityDistricts 
WITH SCHEMABINDING
AS
SELECT
	[SecurityID] = ROW_NUMBER() OVER (ORDER BY U.UserRole)
	,[UserRole] = U.UserRole
	,[UserID] = U.UserID
	,[Username] = U.UserName
	,[DistrictID] = D.DistrictID
	,[DistrictName] = D.DistrictName
FROM dbo.Users AS U
INNER JOIN dbo.District AS D
ON U.DistrictID = D.DistrictID
WHERE U.UserRole = 'disadmin';

GO

