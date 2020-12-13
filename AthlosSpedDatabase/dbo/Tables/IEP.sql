CREATE TABLE [dbo].[IEP] (
    [IEPKey]               INT            IDENTITY (1, 1) NOT NULL,
    [IEPID]                INT            CONSTRAINT [dfIEPID] DEFAULT (NEXT VALUE FOR [seq_IEPID]) NOT NULL,
    [StudentID]            INT            NOT NULL,
    [IEPName]              NVARCHAR (40)  NOT NULL,
    [IEPGoal]              NVARCHAR (MAX) NOT NULL,
    [IEPStartDate]         DATE           NOT NULL,
    [IEPEndDate]           DATE           NOT NULL,
    [IEPTrackingCode]      NVARCHAR (25)  NOT NULL,
    [IEPTrackingDate]      DATE           CONSTRAINT [dfIEPTrackingDate] DEFAULT (getdate()) NOT NULL,
    [IEPTrackingReason]    NVARCHAR (100) NOT NULL,
    [IEPIsCurrent]         BIT            CONSTRAINT [dfIEPIsCurrent] DEFAULT ((1)) NOT NULL,
    [PlannedGoalHours]     INT            NULL,
    [PlannedGoalHoursFreq] NVARCHAR (25)  NULL,
    [GoalServiceAreaID]    INT            DEFAULT ((0)) NOT NULL,
    [IsSync]               BIT            CONSTRAINT [dfIsSync] DEFAULT ((0)) NULL,
    CONSTRAINT [pkIEPKey] PRIMARY KEY CLUSTERED ([IEPKey] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ixIEPGoaLServiceArea]
    ON [dbo].[IEP]([GoalServiceAreaID] ASC)
    INCLUDE([StudentID], [IEPName]);


GO

CREATE NONCLUSTERED INDEX [ixIEPServiceAreas]
    ON [dbo].[IEP]([IEPIsCurrent] ASC, [GoalServiceAreaID] ASC);


GO

CREATE NONCLUSTERED INDEX [ixIEPName]
    ON [dbo].[IEP]([IEPName] ASC);


GO

CREATE   -- Insert school info from customers
TRIGGER dbo.tInsertIntoIEPs
ON dbo.IEP
AFTER INSERT
AS
	UPDATE dbo.IEP
	SET IEPID = NEXT VALUE FOR seq_IEPID
	WHERE IEPID = 0;

GO

CREATE     -- Fill the IEP Plan table everytime a new IEP key is created
TRIGGER [dbo].[tUpdateIEPPlan]
ON [dbo].[IEP]
AFTER INSERT
AS
	BEGIN TRY
		EXECUTE pFillIEPPlan;
	END TRY
	BEGIN CATCH
		Print Error_Message();
	END CATCH

GO


CREATE TRIGGER UpdateStudentIEPSnapshotID
ON IEP
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	/*
	CREATED BY Hayden Parkinson (hparkinson@athlos.org)
	DESC: Updates a student object "SnapshotID" whenever an associated IEP is modified
		SnapshotID can then be queried by a user to know 
		if their student's IEP list in local storage is up to date or not
		This allows for more efficient syncing between devices and the database
	*/
	SET NOCOUNT ON;
	UPDATE Student
	SET IEPSnapshotID = IEPSnapshotID + 1
	WHERE StudentID IN (SELECT StudentID FROM INSERTED UNION SELECT StudentID FROM DELETED)
END

GO

