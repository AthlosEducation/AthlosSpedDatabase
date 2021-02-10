SELECT * FROM ReportsTable;
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
    ,HasGoalFilter BIT NOT NULL
    ,HasDatesFilter BIT NOT NULL
    ,DistrictID INT NOT NULL
);
GO

SELECT * FROM Reports;
GO

INSERT INTO dbo.Reports (ReportName, ReportDescription, ReportType, IsDefault, HasSchoolFilter, HasUserFilter, HasStudentFilter, HasGoalFilter, HasDatesFilter, DistrictID)
SELECT 
    CAST(ReportName AS NVARCHAR(100))
    ,CAST(ReportDescription AS NVARCHAR(500))
    ,CAST(ReportType AS NVARCHAR(50))
    ,CAST(IsDefault AS BIT)
    ,CAST(HasSchoolFilter AS BIT)
    ,CAST(HasUserFilter AS BIT)
    ,CAST(HasStudentFilter AS BIT)
    ,CAST(HasDatesFilter AS BIT)
    ,CAST(HasGoalFilter AS BIT)
    ,CAST(DistrictID AS INT)
FROM ReportsTable;
GO

ALTER TABLE Reports
ADD CONSTRAINT pkReportID PRIMARY KEY (ReportID);
GO

DROP TABLE ReportsTable;