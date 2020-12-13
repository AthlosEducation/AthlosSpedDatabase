CREATE  
VIEW vSecurityProgressMonitoring
AS
Select
	[ProgressMonitoringID] = P.ProgressMonitoringID
	,[UserID] = U.UserID
	,[Username] = U.Username
FROM dbo.ProgressMonitoring AS P
INNER JOIN dbo.Users AS U
ON P.DistrictID = U.DistrictID
WHERE U.UserRole = 'disadmin'
UNION
Select
	[ProgressMonitoringID] = P.ProgressMonitoringID
	,[UserID] = U.UserID
	,[Username] = U.Username
FROM dbo.ProgressMonitoring AS P
INNER JOIN dbo.Users AS U
ON P.SchoolID = U.SchoolID
WHERE U.UserRole = 'schoadmin'
UNION
Select
	[ProgressMonitoringID] = P.ProgressMonitoringID
	,[UserID] = U.UserID
	,[Username] = U.Username
FROM dbo.ProgressMonitoring AS P
INNER JOIN dbo.Users AS U
ON P.UserID = U.UserID;

GO

