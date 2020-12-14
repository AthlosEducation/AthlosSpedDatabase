-- Connect to the latest backup file and run this script.

-----DROP ALL PROCEDURES THAT RELY ON EXTERNAL SOURCES -----
DROP PROC pETLSyncIEPs;
DROP PROC pETLSyncStudents;
 
 -----DROP ALL VIEWS THAT RELY ON EXTERNAL SOURCES -----
DROP VIEW vCheckStudentIDs;
DROP VIEW vETLIEPs;
DROP VIEW vETLStudents;
DROP VIEW vMatchDistrictID;
DROP VIEW vMatchSchoolID;
DROP VIEW vProdDBStudentSelector;
DROP VIEW vStagingIEPs;
DROP VIEW vStagingStudents;
DROP VIEW vStudentIDLinker;
GO

 -----DROP ALL EXTERNAL TABLES -----
DROP EXTERNAL TABLE dbo.Orgs;
DROP EXTERNAL TABLE dbo.Schools;
DROP EXTERNAL TABLE dbo.StagingIEPs;
DROP EXTERNAL TABLE dbo.Students;
GO


 -----DROP ALL EXTERNAL DATA SOURCES -----
DROP EXTERNAL DATA SOURCE StagingDatabase;
GO