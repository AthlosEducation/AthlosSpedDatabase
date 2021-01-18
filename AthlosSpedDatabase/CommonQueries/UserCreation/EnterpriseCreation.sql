SELECT * FROM Customers;
GO

-- First insert individual customer information into customers table

INSERT INTO dbo.Customers (CustomerContactFirstName, CustomerContactLastName, CustomerContactEmail, CustomerLicenseType, CustomerLicenseName, CustomerLicenses, CustomerStartDate, CustomerEndDate, CustomerIsCurrent, CustomerPrimaryDeviceType, CustomerSecondaryDeviceType)
VALUES (
	'Corinne' -- FirstName of primary contact
	,'Altrichter' -- LastName or primary contact
	,'caltrichter@mnic.org' -- Email or primary contact
	,'District' -- District
	,'Minnesota Internship Center' -- District Name
	,6 -- Number of users
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
	('Downtown',1,1,66,91,0) -- Update school name, districtID, and customerID
	,('Rondo',1,1,66,91,0) -- Update school name, districtID, and customerID
	,('SOAR',1,1,66,91,0) -- Update school name, districtID, and customerID
	,('Unity',1,1,66,91,0); -- Update school name, districtID, and customerID
GO

SELECT * FROM School;

-- Go and create all user profiles in the admin portal.