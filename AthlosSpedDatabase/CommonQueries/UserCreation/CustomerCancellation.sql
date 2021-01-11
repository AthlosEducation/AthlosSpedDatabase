SELECT * FROM Customers;
GO

-- UDPATE CANCELLED CUSTOMERS TO REMOVE ACCESS

UPDATE dbo.Customers
SET CustomerIsCurrent = 0
WHERE CustomerID = 70;
GO

UPDATE dbo.Customers
SET CustomerEndDate = '2021-01-09'
WHERE CustomerID = 70;
GO

-- DELETE TEST CUSTOMERS, DISTRICTS, AND SCHOOLS

DELETE FROM School WHERE DistrictID IN (
    SELECT DistrictID FROM District WHERE CustomerID IN (
        SELECT CustomerID FROM Customers WHERE CustomerContactEmail LIKE '%test%')
        );
GO

DELETE FROM District WHERE CustomerID IN (
    SELECT CustomerID FROM Customers WHERE CustomerContactEmail LIKE '%test%');
GO

DELETE FROM Customers WHERE CustomerContactEmail LIKE '%test%';
GO