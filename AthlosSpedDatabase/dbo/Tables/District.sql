CREATE TABLE [dbo].[District] (
    [DistrictID]   INT            IDENTITY (1, 1) NOT NULL,
    [DistrictName] NVARCHAR (100) NOT NULL,
    [CustomerID]   INT            NOT NULL,
    [SISEnabled]   BIT            DEFAULT ((0)) NOT NULL,
    [SISURL]       NVARCHAR (300) NULL,
    [SISKey]       NVARCHAR (300) NULL,
    [SISSecret]    NVARCHAR (300) NULL,
    [IEPEnabled]   BIT            DEFAULT ((0)) NOT NULL,
    [IEPURL]       NVARCHAR (300) NULL,
    [IEPKey]       NVARCHAR (300) NULL,
    [IEPSecret]    NVARCHAR (300) NULL,
    CONSTRAINT [pkDistrictID] PRIMARY KEY CLUSTERED ([DistrictID] ASC),
    CONSTRAINT [fkDistrictsToCustomers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID])
);


GO

