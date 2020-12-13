CREATE  
VIEW [dbo].[vUsers]
WITH SCHEMABINDING
AS
SELECT TOP 100000000000
	[UserID] = U.UserID
	,[Username] = U.UserName
	,[UserEmail] = U.UserEmail
	,[UserFirstName] = U.UserFirstName
	,[UserLastName] = U.UserLastName
	,[ProviderName] = U.UserFirstName +' ' + U.UserLastName
	,[UserRole] = U.UserRole
	,[UserIsCurrent] = U.UserIsCurrent
	,[AspNetUserID] = U.AspNetUserID
	,[SchoolID] = U.SchoolID
	,[SchoolName] = SC.SchoolName
	,[DistrictID] = U.DistrictID
	,[DistrictName] = D.DistrictName
	,[AddIEPAllowed] = U.AddIEPAllowed
	,[AddStudentsAllowed] = U.AddStudentsAllowed
	,[ManageCaseloadAllowed] = U.ManageCaseloadAllowed
FROM dbo.Users AS U
LEFT OUTER JOIN dbo.School AS SC
ON U.SchoolID = SC.SchoolID
INNER JOIN dbo.District AS D
ON D.DistrictID = U.DistrictID
ORDER BY U.UserID, [ProviderName] ASC;

GO

