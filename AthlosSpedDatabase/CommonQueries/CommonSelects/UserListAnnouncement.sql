-- Run this query on production database to get list of users to send quarterly app updates too

SELECT
	[Name] = U.UserFirstName + ' ' + U.UserLastName
	,U.UserEmail
	,U.UserRole
	,D.DistrictName
	,C.CustomerLicenseType
FROM dbo.Users AS U
INNER JOIN dbo.District AS D ON D.DistrictID = U.DistrictID
INNER JOIN dbo.Customers AS C ON C.CustomerID = D.CustomerID
WHERE (UserIsCurrent = 1 AND U.DistrictID <>7) OR (AspNetUserID IS NULL AND (U.DistrictID <> 7 AND U.DistrictID <> 1 AND U.DistrictID <> 23))
ORDER BY
	C.CustomerLicenseType
	,D.DistrictName
	,CASE
		WHEN U.UserRole = 'disadmin' THEN 1
		WHEN U.UserRole = 'schoadmin' THEN 2
		ELSE 3
	END;
GO