CREATE  
VIEW vSecurityPBI
AS
Select
	[LogID] = L.LogID
	,[UserID] = U.UserID
	,[Username] = U.Username
FROM dbo.Log AS L
INNER JOIN dbo.Users AS U
ON L.DistrictID = U.DistrictID
WHERE U.UserRole = 'disadmin'
UNION
Select
	[LogID] = L.LogID
	,[UserID] = U.UserID
	,[Username] = U.Username
FROM dbo.Log AS L
INNER JOIN dbo.Users AS U
ON L.SchoolID = U.SchoolID
WHERE U.UserRole = 'schoadmin'
UNION
Select
	[LogID] = L.LogID
	,[UserID] = U.UserID
	,[Username] = U.Username
FROM dbo.Log AS L
INNER JOIN dbo.Users AS U
ON L.UserID = U.UserID;

GO

