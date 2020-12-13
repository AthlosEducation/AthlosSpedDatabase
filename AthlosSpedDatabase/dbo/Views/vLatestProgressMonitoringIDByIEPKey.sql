CREATE  
VIEW vLatestProgressMonitoringIDByIEPKey
WITH SCHEMABINDING
AS
SELECT  	
	IEPKey
	,[MaxProgressID] = MAX(ProgressMonitoringID)
FROM dbo.ProgressMonitoring
WHERE WasAbsent = 0
GROUP BY IEPKey

GO

