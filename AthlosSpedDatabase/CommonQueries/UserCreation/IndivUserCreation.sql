SELECT * FROM Customers;
GO

-- First insert individual customer information into customers table

INSERT INTO dbo.Customers (CustomerContactFirstName, CustomerContactLastName, CustomerContactEmail, CustomerLicenseType, CustomerLicenseName, CustomerLicenses, CustomerStartDate, CustomerEndDate, CustomerIsCurrent, CustomerPrimaryDeviceType, CustomerSecondaryDeviceType)
VALUES (
	'Vicki' -- FirstName
	,'Farris' -- LastName
	,'Vicki.farris33@gmail.com' -- Email
	,'Individual' -- Individual
	,'Vicki Farris' -- FullName
	,50 -- Number of students
	,CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE) -- Current date (dont change)
	,NULL -- always null for individuals
	,1 -- always 1
	,'iOS' -- Guess at what device they are using
	,'Windows' -- Guess at second device they would use
);
GO

SELECT * FROM Customers;
GO

-- Now create an associated district for that individual customer

SELECT * FROM District;
GO

INSERT INTO dbo.District (DistrictName, CustomerID, SISEnabled, IEPEnabled)
VALUES (
	'Vicki Farris Individual' -- Fill in with individuals name
	,67 -- CustomerID fill in with new
	,0 -- Always 0 for individuals
	,0 -- Always 0 for individuals
);
GO

SELECT * FROM District;
GO

-- Now create an associated school for that individual customer

INSERT INTO dbo.School (SchoolName, SISEnabled, IEPEnabled, DistrictID, CustomerID, StudentSnapshotID)
VALUES (
	'Vicki Farris Students' -- Fill in with individuals name
	,0 -- Always 0 for individuals
	,0 -- Always 0 for individuals
	,41 -- DistrictID fill in with new
	,67 -- Customer ID fill in with new
	,0
);
GO

SELECT * FROM School;

-- Go and create the new user profile in the admin portal and assign the user profile your email then send activation email to yourself.


-- Update user profile to correct email.

SELECT * FROM dbo.Users;
GO

UPDATE dbo.Users
SET UserName = 'cporter747@yahoo.com' -- Update with real email
WHERE UserID = 347; -- Update with new UserID
GO

UPDATE dbo.Users
SET UserEmail = 'cporter747@yahoo.com' -- Update with real email
WHERE UserID = 347; -- Update with new UserID
GO