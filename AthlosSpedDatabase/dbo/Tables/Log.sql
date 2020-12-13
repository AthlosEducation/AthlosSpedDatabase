CREATE TABLE [dbo].[Log] (
    [LogID]         INT              IDENTITY (1, 1) NOT NULL,
    [DistrictID]    INT              NOT NULL,
    [SchoolID]      INT              NOT NULL,
    [UserID]        INT              NOT NULL,
    [StudentKey]    INT              NOT NULL,
    [IEPKey]        INT              NOT NULL,
    [SchoolYearID]  INT              NOT NULL,
    [Date]          DATE             NOT NULL,
    [ServiceArea]   NVARCHAR (100)   NOT NULL,
    [SessionRecord] NVARCHAR (MAX)   NOT NULL,
    [StartTime]     TIME (7)         NOT NULL,
    [EndTime]       TIME (7)         NOT NULL,
    [Hours]         DECIMAL (18, 2)  NOT NULL,
    [FileUpload]    NVARCHAR (MAX)   NULL,
    [WasAbsent]     BIT              CONSTRAINT [dfWasAbsetLog] DEFAULT ((0)) NOT NULL,
    [ClientGUID]    UNIQUEIDENTIFIER NULL,
    CONSTRAINT [pkLogID] PRIMARY KEY CLUSTERED ([LogID] ASC),
    CONSTRAINT [fkLogsToDistricts] FOREIGN KEY ([DistrictID]) REFERENCES [dbo].[District] ([DistrictID]),
    CONSTRAINT [fkLogsToIEPs] FOREIGN KEY ([IEPKey]) REFERENCES [dbo].[IEP] ([IEPKey]),
    CONSTRAINT [fkLogsToSchools] FOREIGN KEY ([SchoolID]) REFERENCES [dbo].[School] ([SchoolID]),
    CONSTRAINT [fkLogsToSchoolYears] FOREIGN KEY ([SchoolYearID]) REFERENCES [dbo].[SchoolYears] ([SchoolYearID]),
    CONSTRAINT [fkLogsToStudents] FOREIGN KEY ([StudentKey]) REFERENCES [dbo].[Student] ([StudentKey]),
    CONSTRAINT [fkLogsToUsers] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
);


GO

CREATE NONCLUSTERED INDEX [ixLogDetail]
    ON [dbo].[Log]([Date] ASC)
    INCLUDE([UserID], [StudentKey], [IEPKey], [Hours], [WasAbsent]);


GO

CREATE NONCLUSTERED INDEX [ixLogsIndex]
    ON [dbo].[Log]([DistrictID] ASC, [SchoolID] ASC, [UserID] ASC, [StudentKey] ASC, [IEPKey] ASC, [SchoolYearID] ASC);


GO

CREATE NONCLUSTERED INDEX [ixLogsIEPNotes]
    ON [dbo].[Log]([StudentKey] ASC, [IEPKey] ASC)
    INCLUDE([SessionRecord], [Hours]);


GO

CREATE NONCLUSTERED INDEX [ixLogDateStudent]
    ON [dbo].[Log]([IEPKey] ASC, [Date] ASC)
    INCLUDE([StudentKey]);


GO

