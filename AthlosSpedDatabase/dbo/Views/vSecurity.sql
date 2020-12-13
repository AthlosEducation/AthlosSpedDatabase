CREATE
VIEW vSecurity
AS
SELECT
	[SecurityID] = UserID
	,Username
	,UserRole
	,SchoolID
	,DistrictID
FROM Users;

GO

