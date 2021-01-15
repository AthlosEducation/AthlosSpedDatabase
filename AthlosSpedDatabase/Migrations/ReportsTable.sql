SELECT * FROM reportsStag;
GO

CREATE TABLE dbo.Reports (
    ReportID INT IDENTITY(1,1) NOT NULL 
    ,ReportName NVARCHAR(100) NOT NULL
    ,ReportDescription NVARCHAR(500) NOT NULL
    ,ReportType NVARCHAR(50) NOT NULL
    ,IsDefault BIT NOT NULL
    ,HasSchoolFilter BIT NOT NULL
    ,HasUserFilter BIT NOT NULL
    ,HasStudentFilter BIT NOT NULL
    ,HasDatesFilter BIT NOT NULL
    ,DistrictID INT NOT NULL
    ,RunCount INT NOT NULL
    ,LastRun DATE NOT NULL
    ,LastRunBy INT NOT NULL
);
GO

SELECT * FROM Reports;
GO

INSERT INTO dbo.Reports (ReportName, ReportDescription, ReportType, IsDefault, HasSchoolFilter, HasUserFilter, HasStudentFilter, HasDatesFilter, DistrictID, RunCount, LastRun, LastRunBy)
SELECT 
    CAST(ReportName AS NVARCHAR(100))
    ,CAST(ReportDescription AS NVARCHAR(500))
    ,CAST(ReportType AS NVARCHAR(50))
    ,CAST(IsDefault AS BIT)
    ,CAST(HasSchoolFilter AS BIT)
    ,CAST(HasUserFilter AS BIT)
    ,CAST(HasStudentFilter AS BIT)
    ,CAST(HasDatesFilter AS BIT)
    ,CAST(DistrictID AS INT)
    ,CAST(RunCount AS INT)
    ,CAST(LastRun AS DATE)
    ,CAST(LastRunBy AS INT)
FROM reportsStag;
GO

ALTER TABLE Reports
ADD CONSTRAINT pkReportID PRIMARY KEY (ReportID);
GO

DROP TABLE reportsStag;