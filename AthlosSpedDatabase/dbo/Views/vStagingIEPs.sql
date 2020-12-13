

CREATE
VIEW [dbo].[vStagingIEPs]
AS
SELECT
	[StudentStateID] = I.StudentStateID,
	[GoalName],
	[GoalStatement],
	[GoalStartDate],
	[GoalEndDate],
	[GoalServiceAreaID],
	[StudentNumber] = I.StudentNumber,
	StudentID = S.StudentID
FROM StagingIEPs AS I
INNER JOIN Student AS S
ON CONCAT(I.StudentStateID, I.StudentNumber) = CONCAT(S.StudentStateID, S.StudentNumber)
WHERE S.StudentIsCurrent = 1;

GO

