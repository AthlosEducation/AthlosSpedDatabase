

CREATE PROCEDURE [dbo].[pCreateIndividualUser]
	(@FirstName NVARCHAR(100)
	,@LastName NVARCHAR(100)
	,@Email NVARCHAR(100))
AS
	BEGIN
		DECLARE @RC INT = 0
			BEGIN TRY		

				-- Insert into the customers table
				INSERT INTO dbo.Customers (CustomerContactFirstName, CustomerContactLastName, CustomerContactEmail, CustomerLicenseType, CustomerLicenseName, CustomerLicenses, CustomerStartDate, CustomerEndDate, CustomerIsCurrent, CustomerPrimaryDeviceType, CustomerSecondaryDeviceType)
				VALUES (
					@FirstName
					,@LastName
					,@Email
					,'Individual'
					,@FirstName + ' ' + @LastName
					,50
					,CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
					,NULL
					,1 
					,'iOS'
					,'Windows');

				-- Insert into the district table
				INSERT INTO dbo.District (DistrictName, CustomerID, SISEnabled, IEPEnabled)
				SELECT
					[DistrictName] = (@FirstName + ' ' + @LastName + ' ' + ' Individual')
					,CustomerID
					,0
					,0
				FROM Customers
				WHERE CustomerContactEmail = @Email;

				-- Insert into school table
				INSERT INTO dbo.School (SchoolName, SISEnabled, IEPEnabled, DistrictID, CustomerID, StudentSnapshotID)
				SELECT
					[SchoolName] = (@FirstName + ' ' + @LastName + ' ' + ' Students')
					,0 -- Always 0 for individuals
					,0 -- Always 0 for individuals
					,DistrictID -- DistrictID fill in with new
					,CustomerID -- Customer ID fill in with new
					,0
				FROM District
				WHERE [DistrictName] = (@FirstName + ' ' + @LastName + ' ' + ' Individual');

				--Insert into users table
				INSERT INTO dbo.Users (UserName,UserEmail,UserFirstName,UserLastName,UserRole,UserIsCurrent,SchoolID,DistrictID,AspNetUserID,CleverID,AddIEPAllowed,EditIEPAllowed,AddStudentsAllowed,ManageCaseloadAllowed)
				SELECT
					@Email
					,@Email
					,@FirstName
					,@LastName
					,'provider'
					,0
					,SchoolID
					,DistrictID
					,NULL
					,NULL
					,1
					,1
					,1
					,1
				FROM School
				WHERE [SchoolName] = (@FirstName + ' ' + @LastName + ' ' + ' Students');

				--Insert into school users table
				INSERT INTO dbo.SchoolUser (UserID, SchoolID, DistrictID)
				SELECT
					U.UserID
					,U.SchoolID
					,U.DistrictID
				FROM Users AS U
				INNER JOIN School AS S ON S.SchoolID = U.SchoolID
				WHERE [SchoolName] = (@FirstName + ' ' + @LastName + ' ' + ' Students');

				--Insert into access codes table
				INSERT INTO dbo.AccessCode (Code, [Role], DistrictID, SchoolID, Used, UserID)
				SELECT
					Code = (SUBSTRING(CAST(NEWID() AS NVARCHAR(50)),1,7))
					,'provider'
					,U.DistrictID
					,U.SchoolID
					,0
					,UserID
				FROM Users AS U
				INNER JOIN School AS S ON S.SchoolID = U.SchoolID
				WHERE [SchoolName] = (@FirstName + ' ' + @LastName + ' ' + ' Students');

				-- Select the access code
				SELECT TOP 1 Code
				FROM AccessCode AS AC
				INNER JOIN School AS S ON S.SchoolID = AC.SchoolID
				WHERE [SchoolName] = (@FirstName + ' ' + @LastName + ' ' + ' Students');

			SET @RC = +1
			END TRY

			BEGIN CATCH
				PRINT Error_Message()
				SET @RC = -1
			END CATCH

		RETURN @RC;
	END

GO

