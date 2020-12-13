CREATE TABLE [dbo].[ProgressMonitoring] (
    [ProgressMonitoringID]      INT              IDENTITY (1, 1) NOT NULL,
    [DistrictID]                INT              NOT NULL,
    [SchoolID]                  INT              NOT NULL,
    [UserID]                    INT              NOT NULL,
    [StudentKey]                INT              NOT NULL,
    [IEPKey]                    INT              NOT NULL,
    [SchoolYearID]              INT              NOT NULL,
    [Date]                      DATE             NOT NULL,
    [ProgressMeasurementPeriod] NVARCHAR (50)    NOT NULL,
    [ProgressAssessment]        NVARCHAR (50)    NOT NULL,
    [GoalProgress]              NVARCHAR (50)    NOT NULL,
    [ProgressNotes]             NVARCHAR (MAX)   NULL,
    [ProgressScore]             NVARCHAR (200)   NULL,
    [ProgressFileUpload]        NVARCHAR (MAX)   NULL,
    [ProgressTrialNumber]       INT              NULL,
    [WasAbsent]                 BIT              CONSTRAINT [dfWasAbsetProgressMonitoring] DEFAULT ((0)) NOT NULL,
    [ClientGUID]                UNIQUEIDENTIFIER NULL,
    CONSTRAINT [pkProgressMonitoringID] PRIMARY KEY CLUSTERED ([ProgressMonitoringID] ASC),
    CONSTRAINT [fkProgressMonitoringToDistricts] FOREIGN KEY ([DistrictID]) REFERENCES [dbo].[District] ([DistrictID]),
    CONSTRAINT [fkProgressMonitoringToIEPs] FOREIGN KEY ([IEPKey]) REFERENCES [dbo].[IEP] ([IEPKey]),
    CONSTRAINT [fkProgressMonitoringToSchools] FOREIGN KEY ([SchoolID]) REFERENCES [dbo].[School] ([SchoolID]),
    CONSTRAINT [fkProgressMonitoringToSchoolYears] FOREIGN KEY ([SchoolYearID]) REFERENCES [dbo].[SchoolYears] ([SchoolYearID]),
    CONSTRAINT [fkProgressMonitoringToStudents] FOREIGN KEY ([StudentKey]) REFERENCES [dbo].[Student] ([StudentKey]),
    CONSTRAINT [fkProgressMonitoringToUsers] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
);


GO

CREATE NONCLUSTERED INDEX [ixProgressMonitoringIndex]
    ON [dbo].[ProgressMonitoring]([DistrictID] ASC, [SchoolID] ASC, [UserID] ASC, [StudentKey] ASC, [IEPKey] ASC, [SchoolYearID] ASC);


GO

CREATE TRIGGER tRockyServiceLog
ON dbo.ProgressMonitoring
AFTER INSERT
AS
-- THIS IS A TEMPORARY FIX FOR POWERBI PROGRESS MONITORING VIEWING PROBLEM
INSERT INTO dbo.Log (DistrictID,SchoolID,UserID,StudentKey,IEPKey,SchoolYearID,Date,ServiceArea,SessionRecord,StartTime,EndTime,Hours,FileUpload,WasAbsent,ClientGUID)
SELECT
	DistrictID = P.DistrictID
	,SchoolID = P.SchoolID
	,UserID = P.UserID
	,StudentKey = P.StudentKey
	,IEPKey = P.IEPKey
	,SchoolYearID = P.SchoolYearID
	,Date = P.Date
	,ServiceArea = GSA.ServiceArea
	,SessionRecord = 'Progress Monitoring Session'
	,StartTime = '08:30:00.0000000'
	,EndTime = '09:00:00.0000000'
	,Hours = 0.5
	,FileUpload = NULL
	,WasAbsent = 0
	,ClientGUID = NULL
FROM dbo.ProgressMonitoring AS P
INNER JOIN dbo.IEP AS I ON I.IEPKey = P.IEPKey
INNER JOIN dbo.GoalServiceArea AS GSA ON GSA.ID = I.GoalServiceAreaID
WHERE P.UserID = 109 AND P.IEPKey NOT IN (SELECT IEPKey FROM dbo.Log WHERE UserID = 109);

GO

