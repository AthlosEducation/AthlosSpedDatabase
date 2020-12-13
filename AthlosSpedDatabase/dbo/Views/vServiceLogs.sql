CREATE  
VIEW vServiceLogs
WITH SCHEMABINDING
AS
SELECT
	[LogID] = L.LogID
	,[DistrictID] = L.DistrictID
	,[SchoolID] = L.SchoolID
	,[UserID] = L.UserID
	,[StudentKey] = L.StudentKey
	,[IEPKey] = L.IEPKey
	,[SchoolYearID] = L.SchoolYearID
	,[Date] = L.Date
	,[SessionRecord] = L.SessionRecord
	,[Hours] = L.Hours
	,[Photos] =	IIF(L.FileUpload IS NOT NULL,1,0)
	,[Absences] = IIF(L.WasAbsent = 0,'Student was present','Student was absent')
FROM dbo.Log AS L;

GO

