SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CheckDuplicateGoals]
AS
WITH CTE AS (
    SELECT 
		IEPKey
		,IEPID
		,StudentID
		,IEPName
		,IEPGoal
		,IEPStartDate
		,IEPEndDate
		,IEPTrackingDate
		,IEPIsCurrent
		,GoalServiceAreaID
        ,ROW_NUMBER() OVER (
            PARTITION BY 
				StudentID
				,IEPName
				,IEPGoal
				,IEPStartDate
				,IEPEndDate
				,IEPTrackingDate
				,IEPIsCurrent
				,GoalServiceAreaID
            ORDER BY 
				StudentID
				,IEPName
				,IEPGoal
				,IEPStartDate
				,IEPEndDate
				,IEPTrackingDate
				,IEPIsCurrent
				,GoalServiceAreaID
        ) row_num
     FROM 
        dbo.IEP
)
SELECT * FROM CTE
INNER JOIN dbo.Log ON Log.IEPKey = CTE.IEPKey
WHERE row_num > 1 AND IEPIsCurrent = 1;
GO

GO

EXEC CheckDuplicateGoals;
GO
-- CLEAN UP ARCHIVED IEPs THAT NEVER RECIEVED ANY LOGS AND CAME FROM THE SYNC

SELECT * FROM IEP AS I 
FULL OUTER JOIN dbo.Log AS LOG ON LOG.IEPKey = I.IEPKey
FULL OUTER JOIN dbo.ProgressMonitoring AS P ON P.IEPKey = I.IEPKey
WHERE I.IEPIsCurrent = 0 AND LOG.LogID IS NULL AND P.ProgressMonitoringID IS NULL;
GO

DELETE FROM IEP WHERE IEPKey IN (SELECT I.IEPKey FROM IEP AS I 
FULL OUTER JOIN dbo.Log AS LOG ON LOG.IEPKey = I.IEPKey
FULL OUTER JOIN dbo.ProgressMonitoring AS P ON P.IEPKey = I.IEPKey
WHERE I.IEPIsCurrent = 0 AND I.IsSync = 1 AND LOG.LogID IS NULL AND P.ProgressMonitoringID IS NULL);
GO

-- CLEAN UP ARCHIVED STUDENTS THAT NEVER RECIEVED ANY LOGS

SELECT * FROM Student AS S 
FULL OUTER JOIN dbo.Log AS LOG ON Log.StudentKey = S.StudentKey
FULL OUTER JOIN dbo.ProgressMonitoring AS P ON P.StudentKey = S.StudentKey
WHERE S.StudentIsCurrent = 0 AND LOG.LogID IS NULL AND P.ProgressMonitoringID IS NULL;
GO

DELETE FROM Student WHERE StudentKey IN (SELECT S.StudentKey FROM Student AS S 
FULL OUTER JOIN dbo.Log AS LOG ON Log.StudentKey = S.StudentKey
FULL OUTER JOIN dbo.ProgressMonitoring AS P ON P.StudentKey = S.StudentKey
WHERE S.StudentIsCurrent = 0 AND LOG.LogID IS NULL AND P.ProgressMonitoringID IS NULL);
GO