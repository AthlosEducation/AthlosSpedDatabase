CREATE TABLE [dbo].[School] (
    [SchoolID]          INT            IDENTITY (1, 1) NOT NULL,
    [SchoolName]        NVARCHAR (100) NOT NULL,
    [SISEnabled]        BIT            NOT NULL,
    [SISURL]            NVARCHAR (300) NULL,
    [SISKey]            NVARCHAR (300) NULL,
    [SISSecret]         NVARCHAR (300) NULL,
    [IEPEnabled]        BIT            NOT NULL,
    [IEPURL]            NVARCHAR (300) NULL,
    [IEPKey]            NVARCHAR (300) NULL,
    [IEPSecret]         NVARCHAR (300) NULL,
    [DistrictID]        INT            NOT NULL,
    [CustomerID]        INT            NOT NULL,
    [StudentSnapshotID] INT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [pkSchoolID] PRIMARY KEY CLUSTERED ([SchoolID] ASC),
    CONSTRAINT [fkSchoolsToCustomers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID])
);


GO

