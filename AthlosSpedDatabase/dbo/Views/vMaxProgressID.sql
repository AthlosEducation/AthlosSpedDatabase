CREATE  
VIEW vMaxProgressID
WITH SCHEMABINDING
AS
SELECT
	t.ProgressMonitoringID
	,v.MaxProgressID
FROM dbo.ProgressMonitoring AS T
FULL OUTER JOIN dbo.vLatestProgressMonitoringIDByIEPKey AS v
ON t.ProgressMonitoringID = v.MaxProgressID;

GO

