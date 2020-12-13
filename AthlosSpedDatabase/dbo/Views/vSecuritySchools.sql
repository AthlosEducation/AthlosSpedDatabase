CREATE   
VIEW [dbo].[vSecuritySchools]
WITH SCHEMABINDING
AS
SELECT
	[SecurityID] = ROW_NUMBER() OVER (ORDER BY U.UserID)
	,[UserRole] = U.UserRole
	,[UserID] = U.UserID
	,[Username] = U.UserName
	,[SchoolID] = SU.SchoolID
	,[SchoolName] = S.SchoolName
FROM dbo.Users AS U
LEFT OUTER JOIN dbo.SchoolUser AS SU
ON SU.UserID = U.UserID
INNER JOIN dbo.School AS S
ON S.SchoolID = SU.SchoolID
WHERE U.UserRole = 'schoadmin';

GO

