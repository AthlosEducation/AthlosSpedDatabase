SELECT * FROM Customers;
GO

-- First insert individual customer information into customers table

INSERT INTO dbo.Customers (CustomerContactFirstName, CustomerContactLastName, CustomerContactEmail, CustomerLicenseType, CustomerLicenseName, CustomerLicenses, CustomerStartDate, CustomerEndDate, CustomerIsCurrent, CustomerPrimaryDeviceType, CustomerSecondaryDeviceType)
VALUES (
	'Christine' -- FirstName of primary contact
	,'Baxter' -- LastName or primary contact
	,'christine.baxter@sessnv.com' -- Email or primary contact
	,'District' -- District
	,'Mater Academy - Nevada' -- District Name
	,40 -- Number of users
	,CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE) -- Current date (dont change)
	,NULL -- always null for enterprises
	,1 -- always 1
	,'iOS' -- Guess at what device they are using
	,'Windows' -- Guess at second device they would use
);
GO

SELECT * FROM Customers;
GO

-- District then gets automatically created based on insert statement above

SELECT * FROM District;
GO

-- Now create an associated schools for that enterprise customer

INSERT INTO dbo.School (SchoolName, SISEnabled, IEPEnabled, DistrictID, CustomerID, StudentSnapshotID)
VALUES 
	('Mater Bonanza',1,1,72,97,0) -- Update school name, districtID, and customerID
	,('Mater East',1,1,72,97,0) -- Update school name, districtID, and customerID
	,('Mater Mountain Vista',1,1,72,97,0); -- Update school name, districtID, and customerID
GO

SELECT * FROM School;

-- Go and create all user profiles in the admin portal.