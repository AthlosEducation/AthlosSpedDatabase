CREATE  
VIEW vIEPForPowerBI
WITH SCHEMABINDING
AS
SELECT
	I.IEPKey
	,IEPID
	,I.StudentID
	,[StudentName] = (SELECT MAX(S.StudentFirstName) + ' ' + MAX(S.StudentLastName) FROM dbo.Student AS S WHERE I.StudentID = S.StudentID)
	,[IEPGoalSubject] = G.ServiceArea
	,IEPName
	,IEPGoal
	,IEPStartDate
	,IEPEndDate
	,IEPTrackingReason
	,IEPIsCurrent
	,[IEPStatus] = IIF(IEPTrackingCode = 'Archived', 'Archived', 'Current')
	,[AbsentStatus] = IIF(IEPName = 'Absent', 'Absent', 'Present for session')
	,[GoalDetail] = 'Goal: ' + IEPGoal 
	,[GoalTracking] =	CASE
							WHEN IEPTrackingCode = 'Created' AND IEPID <> 468 THEN CONCAT('This goal was ' , IEPTrackingCode , ' on ' , IEPTrackingDate)--, ' Goal Start Date:  ' , IEPStartDate  , ' Goal End Date: ' , IEPEndDate)
							WHEN IEPTrackingCode = 'Edited' THEN CONCAT('This goal was ' , IEPTrackingCode , ' on ' , IEPTrackingDate , ' for the following reasons: ' , IEPTrackingReason)--, ' Goal Start Date:  ' , IEPStartDate , ' Goal End Date: ' , IEPEndDate)
							WHEN IEPTrackingCode = 'Amended' THEN CONCAT('This goal was ' , IEPTrackingCode , ' on ' , IEPTrackingDate , ' for the following reasons: ' , IEPTrackingReason)--, ' Goal Start Date:  ' , IEPStartDate , ' Goal End Date: ' , IEPEndDate)
							WHEN IEPTrackingCode = 'Archived' THEN CONCAT('This goal was ' , IEPTrackingCode , ' on ' , IEPTrackingDate)--, ' Goal Start Date:  ' , IEPStartDate  , ' Goal End Date: ' , IEPEndDate)
							WHEN IEPID = 468 THEN ('Generic goal to capture student absences')
							ELSE 'Please Select IEP Goal Name'
						END
FROM dbo.IEP AS I
INNER JOIN dbo.GoalServiceArea AS G
ON G.ID = I.GoalServiceAreaID;

GO

