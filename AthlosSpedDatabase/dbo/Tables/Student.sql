CREATE TABLE [dbo].[Student] (
    [StudentKey]        INT           IDENTITY (1, 1) NOT NULL,
    [StudentID]         INT           CONSTRAINT [dfStudentID] DEFAULT (NEXT VALUE FOR [seq_StudentID]) NOT NULL,
    [StudentFirstName]  NVARCHAR (50) NOT NULL,
    [StudentLastName]   NVARCHAR (50) NOT NULL,
    [StudentNumber]     NVARCHAR (25) NOT NULL,
    [StudentStateID]    NVARCHAR (25) NULL,
    [StudentGradeLevel] NVARCHAR (2)  NULL,
    [DistrictID]        INT           NOT NULL,
    [SchoolID]          INT           NOT NULL,
    [StudentStartDate]  DATE          CONSTRAINT [dfStudentStartDate] DEFAULT (getdate()) NOT NULL,
    [StudentEndDate]    DATE          NULL,
    [StudentIsCurrent]  BIT           CONSTRAINT [dfStudentIsCurrent] DEFAULT ((1)) NOT NULL,
    [IEPSnapshotID]     INT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [pkStudentKey] PRIMARY KEY CLUSTERED ([StudentKey] ASC),
    CONSTRAINT [fkStudentsToDistricts] FOREIGN KEY ([DistrictID]) REFERENCES [dbo].[District] ([DistrictID]),
    CONSTRAINT [fkStudentsToSchools] FOREIGN KEY ([SchoolID]) REFERENCES [dbo].[School] ([SchoolID])
);


GO

CREATE NONCLUSTERED INDEX [ixStudentIsCurrent]
    ON [dbo].[Student]([StudentIsCurrent] ASC)
    INCLUDE([StudentID], [StudentNumber], [StudentStateID]);


GO

CREATE TRIGGER [dbo].[UpdateStudentSnapshotID_InsertDelete]
ON [dbo].[Student]
AFTER Insert, Delete
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE School
	SET StudentSnapshotID = StudentSnapshotID + 1
	WHERE SchoolID IN (SELECT SchoolID FROM INSERTED UNION SELECT SchoolID FROM DELETED);

	UPDATE Users
	SET CaseloadSnapshotID = CaseloadSnapshotID + 1
	WHERE UserID IN (
		SELECT DISTINCT u.UserID
		FROM (SELECT StudentKey FROM INSERTED UNION SELECT StudentKey FROM DELETED) as i
		INNER JOIN StudentUser AS su ON i.StudentKey = su.StudentKey
		INNER JOIN Users AS u ON su.UserID = u.UserID
		);
END;

GO

CREATE TRIGGER tStudent_UpdateStudentUser
ON Student
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	/*
		Update caseloads to point to new student key
	*/
	INSERT INTO StudentUser(
	UserID,
	StudentKey
	)
	SELECT
		u.UserID,
		i.StudentKey
	FROM
		INSERTED as i
		INNER JOIN Student as s
		ON i.StudentID = s.StudentID
		INNER JOIN StudentUser as su
		ON su.StudentKey = s.StudentKey
		INNER JOIN Users as u
		ON su.UserID = u.UserID

	/*
		Delete references to old student keys
		TODO: Decide whether or not to optimize this (currently scans the whole table)
	*/
	DELETE FROM StudentUser
	WHERE EXISTS 
		(SELECT 1
		FROM Student
		WHERE Student.StudentKey = StudentUser.StudentKey
			AND Student.StudentIsCurrent = 0)
		

END

GO

CREATE TRIGGER [dbo].[UpdateStudentSnapshotID_Update]
ON [dbo].[Student]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE School
	SET StudentSnapshotID = StudentSnapshotID + 1
	WHERE SchoolID IN (SELECT DISTINCT i.SchoolID FROM INSERTED AS i INNER JOIN DELETED AS d ON i.StudentKey = d.StudentKey AND i.IEPSnapshotID = d.IEPSnapshotID);

	UPDATE Users
	SET CaseloadSnapshotID = CaseloadSnapshotID + 1
	WHERE UserID IN (
		SELECT DISTINCT u.UserID 
		FROM INSERTED AS i 
		INNER JOIN DELETED AS d on i.StudentKey = d.StudentKey AND i.IEPSnapshotID = d.IEPSnapshotID 
		INNER JOIN StudentUser AS su on su.StudentKey = i.StudentKey 
		INNER JOIN Users as u on u.UserID = su.UserID
		);
END

GO

CREATE TRIGGER Student_UpdateCaseloadSnapshotID
ON Student
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE u
	SET CaseloadSnapshotID = CaseloadSnapshotID + 1
	FROM INSERTED AS i
	INNER JOIN StudentUser as su
	ON i.StudentKey = su.StudentKey
	INNER JOIN Users AS u
	ON u.UserID = su.UserID
END

GO





CREATE   -- Insert studentID
TRIGGER [dbo].[tInsertStudentID]
ON [dbo].[Student]
AFTER INSERT
AS

	DECLARE @StudentID INT = NEXT VALUE FOR seq_StudentID

	-- Update student ID to next value in sequence
	UPDATE dbo.Student
	SET StudentID = @StudentID
	WHERE StudentID = 0;

GO



CREATE   -- Insert studentID
TRIGGER [dbo].[tInsertStudentStartDate]
ON [dbo].[Student]
AFTER INSERT
AS
	UPDATE dbo.Student
	SET StudentStartDate = GETDATE()
	WHERE StudentStartDate = '0001-01-01';

GO

