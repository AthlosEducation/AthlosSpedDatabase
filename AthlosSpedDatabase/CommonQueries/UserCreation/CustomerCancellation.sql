SELECT * FROM Customers;
GO

UPDATE dbo.Customers
SET CustomerIsCurrent = 0
WHERE CustomerID = 60;
GO

UPDATE dbo.Customers
SET CustomerEndDate = '2021-01-02'
WHERE CustomerID = 60;
GO