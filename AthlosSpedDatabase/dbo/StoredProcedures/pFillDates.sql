/****** [dbo].[DimDates] ******/
CREATE   PROCEDURE pFillDates
/* Author: Christian Macdonald
** Desc: Inserts data into DimDates
** Change Log: When,Who,What
** 2020-04-26,Christian Macdonald,Created Sproc.
*/
AS
	BEGIN
		DECLARE @RC INT = 0;
			BEGIN TRY
				-- ETL Processing Code --
				DELETE FROM Dates; -- Clears table data with the need for dropping FKs
				DECLARE @StartDate DATETIME = '01/01/2018' --< NOTE THE DATE RANGE!
				DECLARE @EndDate DATETIME = '12/31/2030' --< NOTE THE DATE RANGE! 
				DECLARE @DateInProcess DATETIME  = @StartDate
				-- Loop through the dates until you reach the end date
				WHILE @DateInProcess <= @EndDate
					BEGIN
						-- Add a row into the date dimension table for this date
						INSERT INTO Dates 
						( [DateKey], [FullDate], [FullDateName], [MonthID], [MonthName], [YearID], [YearName], [WeekNumber] )
						VALUES ( 
						CAST(CONVERT(nVarchar(50), @DateInProcess, 112) AS INT) -- [DateKey]
						,@DateInProcess -- [FullDate]
						,DATENAME(WEEKDAY, @DateInProcess) + ', ' + CONVERT(NVARCHAR(50), @DateInProcess, 110) -- [FullDateName]  
						,CAST(LEFT(CONVERT(NVARCHAR(50), @DateInProcess, 112), 6) AS INT)  -- [MonthID]
						,DATENAME(MONTH, @DateInProcess) + ' - ' + DATENAME(YYYY,@DateInProcess) -- [MonthName]
						,YEAR(@DateInProcess) -- [YearID] 
						,CAST(YEAR(@DateInProcess ) AS NVARCHAR(50)) -- [YearName] 
						,CAST(CONCAT(DATEPART(WEEK, @DateInProcess),DATEPART(YEAR, @DateInProcess)) AS NVARCHAR(25))
						)  
						-- Add a day and loop again
						SET @DateInProcess = DATEADD(d, 1, @DateInProcess)
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

