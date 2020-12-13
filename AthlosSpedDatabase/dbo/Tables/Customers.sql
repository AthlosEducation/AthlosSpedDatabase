CREATE TABLE [dbo].[Customers] (
    [CustomerID]                  INT            IDENTITY (1, 1) NOT NULL,
    [CustomerContactFirstName]    NVARCHAR (25)  NOT NULL,
    [CustomerContactLastName]     NVARCHAR (25)  NOT NULL,
    [CustomerContactEmail]        NVARCHAR (50)  NOT NULL,
    [CustomerLicenseType]         NVARCHAR (25)  NOT NULL,
    [CustomerLicenseName]         NVARCHAR (100) NOT NULL,
    [CustomerLicenses]            INT            NOT NULL,
    [CustomerStartDate]           DATE           NOT NULL,
    [CustomerEndDate]             DATE           NULL,
    [CustomerIsCurrent]           BIT            NOT NULL,
    [CustomerPrimaryDeviceType]   NVARCHAR (50)  NULL,
    [CustomerSecondaryDeviceType] NVARCHAR (50)  NULL,
    [SchoolAdminManageIEPs]       BIT            NULL,
    [SchoolAdminAddStudents]      BIT            NULL,
    [SchoolAdminManageCaseloads]  BIT            NULL,
    [ProviderManageIEPs]          BIT            NULL,
    [ProviderAddStudents]         BIT            NULL,
    [ProviderManageCaseloads]     BIT            NULL,
    CONSTRAINT [pkCustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [ckCustomerLicensesGreaterThanZero] CHECK ([CustomerLicenses]>(0))
);


GO

CREATE   -- insert district info from customers
TRIGGER dbo.tInsertDistrictFromCustomers
ON dbo.Customers
AFTER INSERT
AS
	MERGE INTO dbo.District AS D
		USING dbo.Customers AS C
		ON C.CustomerID = D.CustomerID
		AND C.CustomerLicenseType = 'District'
	WHEN NOT MATCHED
		AND C.CustomerLicenseType = 'District'
		THEN -- The ID in the Source is not found the the Target 
		INSERT 
			VALUES (
				C.CustomerLicenseName
				,C.CustomerID
				,0
				,NULL
				,NULL
				,NULL
				,0
				,NULL
				,NULL
				,NULL
				)
	WHEN MATCHED -- When the IDs match for the row currently being looked 
		AND (C.CustomerLicenseName <> D.DistrictName) 
		AND (C.CustomerLicenseType = 'District')
		THEN 
		UPDATE 
		SET D.DistrictName = C.CustomerLicenseName;

GO

