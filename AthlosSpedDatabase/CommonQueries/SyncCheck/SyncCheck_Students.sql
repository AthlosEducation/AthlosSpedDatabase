-- First set the date that needs to be checked
DECLARE @DateToCheck DATE
SET @DateToCheck = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
-- Use this query to check which students were updated based on sync and may need to be re-added to caseloads/groups
SELECT
    S.StudentKey
    ,S.StudentID
    ,[StudentName] = S.StudentFirstName + ' ' + S.StudentLastName
    ,S.StudentNumber
    ,S.StudentStateID
    ,S.StudentGradeLevel
    ,D.DistrictName
    ,SC.SchoolName
    ,[New/Update] = IIF(S.StudentEndDate IS NULL,1,0)
    ,[Exit] = IIF(S.StudentEndDate IS NOT NULL,1,0)
    ,S.IEPSnapshotID
FROM Student AS S
INNER JOIN District AS D ON D.DistrictID = S.DistrictID
INNER JOIN School AS SC ON SC.SchoolID = S.SchoolID
INNER JOIN Customers AS C ON C.CustomerID = D.CustomerID
WHERE C.CustomerLicenseType = 'District' AND (S.StudentEndDate = @DateToCheck OR S.StudentStartDate = @DateToCheck);
GO