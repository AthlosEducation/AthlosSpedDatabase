CREATE TABLE [dbo].[StudentsGroups] (
    [StudentsGroupsID] INT IDENTITY (1, 1) NOT NULL,
    [GroupID]          INT NOT NULL,
    [StudentKey]       INT NOT NULL,
    CONSTRAINT [pkStudentsGroupsID] PRIMARY KEY CLUSTERED ([StudentsGroupsID] ASC)
);


GO

CREATE TRIGGER UpdateUserGroupSnapshotID
ON StudentsGroups
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Users
	SET  GroupSnapshotID = GroupSnapshotID + 1
	WHERE UserID IN (
		SELECT DISTINCT u.UserID
		FROM (SELECT GroupID FROM INSERTED 
		UNION SELECT GroupID FROM DELETED) AS sg
		INNER JOIN UsersGroups as ug on ug.GroupID = sg.GroupID
		INNER JOIN Users as u on ug.UserID = u.UserID
	)
END

GO

