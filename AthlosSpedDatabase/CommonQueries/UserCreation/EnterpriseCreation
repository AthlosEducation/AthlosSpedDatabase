SELECT * FROM Customers;
GO

-- First insert individual customer information into customers table

INSERT INTO dbo.Customers (CustomerContactFirstName, CustomerContactLastName, CustomerContactEmail, CustomerLicenseType, CustomerLicenseName, CustomerLicenses, CustomerStartDate, CustomerEndDate, CustomerIsCurrent, CustomerPrimaryDeviceType, CustomerSecondaryDeviceType)
VALUES (
	'Juliet' -- FirstName of primary contact
	,'Gibson' -- LastName or primary contact
	,'juli.gibson@bvcps.net' -- Email or primary contact
	,'District' -- District
	,'Buena Vista City Public Schools' -- District Name
	,15 -- Number of users
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
	('Parry McCluer High School',0,0,23,49,0) -- Update school name, districtID, and customerID
	,('Parry McCluer Middle School',0,0,23,49,0) -- Update school name, districtID, and customerID
	,('Enderly Heights Elementary School',0,0,23,49,0) -- Update school name, districtID, and customerID
	,('F.W. Kling Elementary School',0,0,23,49,0); -- Update school name, districtID, and customerID
GO

SELECT * FROM School;

-- Go and create all user profiles in the admin portal.