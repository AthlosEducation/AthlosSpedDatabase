
CREATE  VIEW [dbo].[vGroups]
WITH SCHEMABINDING
AS
SELECT
	[GroupID] = G.GroupID
	,[GroupName] = G.GroupName
	,[StudentKey] = SG.StudentKey
	,[UserID] = UG.UserID
	,[StudentsGroupsID] = SG.StudentsGroupsID
	,[UsersGroupsID] = UG.UsersGroupsID
FROM dbo.Groups AS G
INNER JOIN dbo.StudentsGroups AS SG
ON SG.GroupID = G.GroupID
INNER JOIN dbo.UsersGroups AS UG
ON UG.GroupID = G.GroupID;

GO

