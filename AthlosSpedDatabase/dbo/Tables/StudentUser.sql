CREATE TABLE [dbo].[StudentUser] (
    [StudentUserID] INT IDENTITY (1, 1) NOT NULL,
    [UserID]        INT NOT NULL,
    [StudentKey]    INT NOT NULL,
    CONSTRAINT [pkStudentUserID] PRIMARY KEY CLUSTERED ([StudentUserID] ASC),
    CONSTRAINT [fkStudentUserToUser] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
);


GO

CREATE TRIGGER UpdateCaseloadSnapshotID
ON [dbo].[StudentUser]
AFTER Insert, Update, Delete
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Users
	SET  CaseloadSnapshotID = CaseloadSnapshotID + 1
	WHERE UserID IN (SELECT DISTINCT UserID FROM INSERTED UNION SELECT DISTINCT UserID FROM DELETED);
END;

GO

