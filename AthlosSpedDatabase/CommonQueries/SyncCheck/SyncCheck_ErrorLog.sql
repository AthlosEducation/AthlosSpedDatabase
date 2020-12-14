-- Connect to the production database
SELECT * FROM dbo.ErrorLog;
GO

-- Fix any issues

-- Truncate the table
TRUNCATE TABLE dbo.ErrorLog;
GO