CREATE PROCEDURE [dbo].[pAthlosUpdateActiveStudentGoals]
AS
------ This procedure finds all the goals associated with current students that do not have a tracking status of Archived and re-activated them

				WITH UpdateActiveStudentGoals 
					AS(
						SELECT *
							FROM IEP
							WHERE StudentID IN (SELECT StudentID FROM Student WHERE StudentIsCurrent = 1 AND DistrictID = 2)
							AND IEPIsCurrent = 0 AND IEPTrackingReason NOT LIKE '%Archived%' 
							AND IEPEndDate > CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE) AND IEPEndDate <> '2021-08-26'
					)
					UPDATE IEP
						SET IEPIsCurrent = 1
						WHERE IEPKey IN (SELECT IEPKey FROM UpdateActiveStudentGoals)
					;

GO

