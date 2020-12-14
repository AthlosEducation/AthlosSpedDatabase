-- Connect to production database and run this query
SELECT
    [MobileCount] = (SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647 AND ClientGUID IS NOT NULL)
    ,[Mobile%] = (CAST((SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647 AND ClientGUID IS NOT NULL) AS DECIMAL(18,2)) / CAST((SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647) AS DECIMAL(18,2))) * 100
    ,[WebCount] = (SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647 AND ClientGUID IS NULL)
    ,[Web%] = (CAST((SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647 AND ClientGUID IS NULL) AS DECIMAL(18,2)) / CAST((SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647) AS DECIMAL(18,2))) * 100
    ,[TotalCount] = (SELECT COUNT(LogID) FROM dbo.Log WHERE LogID > 45647);
GO