/****** [dbo].[IEPPlan] ******/
CREATE   PROCEDURE pFillIEPPlan
/* Author: Christian Macdonald
** Desc: Inserts data into IEPPlan
** Change Log: When,Who,What
** 2020-06-25,Christian Macdonald,Created Sproc.
*/
AS
	BEGIN
		DECLARE @RC INT = 0;
			BEGIN TRY
				--DELETE FROM IEPPlan WHERE IEPIsCurrent = 0; -- Clears table data
				DECLARE @IEPKeyStart INT
				DECLARE @IEPKeyEnd INT = (SELECT MAX(IEPKey) FROM dbo.IEP WHERE IEPKey NOT IN (SELECT IEPKey FROM IEPPlan))

				SET @IEPKeyStart = (SELECT MIN(IEPKey) FROM dbo.IEP WHERE IEPKey NOT IN (SELECT IEPKey FROM IEPPlan))
				WHILE @IEPKeyStart <= @IEPKeyEnd

			BEGIN
				INSERT INTO dbo.IEPPlan
				SELECT 
					--[PlanID] = ROW_NUMBER() OVER (ORDER BY @IEPKeyStart)
					[IEPKey] = @IEPKeyStart
					,[WeekNumber] = CONCAT(DATEPART(wk, WeekStart),DATEPART(yy, WeekStart))
					,[PlannedGoalHours] = CAST((CAST((SELECT I.PlannedGoalHours FROM dbo.IEP AS I WHERE I.IEPKey = @IEPKeyStart) AS DECIMAL(18,2)) / 60) AS DECIMAL(18,2))
				FROM [dbo].[udf-Range-Date](
					(SELECT MIN(I.IEPStartDate) FROM IEP AS I WHERE I.IEPKey = @IEPKeyStart)
					,(SELECT MAX(I.IEPEndDate) FROM IEP AS I WHERE I.IEPKey = @IEPKeyStart)
					,'WK'
					,1);
				SET @IEPKeyStart = @IEPKeyStart + 1
			END
				SET @RC = +1
			END TRY
			BEGIN CATCH
				PRINT Error_Message()
				SET @RC = -1
			END CATCH
		RETURN @RC;
	END

GO

