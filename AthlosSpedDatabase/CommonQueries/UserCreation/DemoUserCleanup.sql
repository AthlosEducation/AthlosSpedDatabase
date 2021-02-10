SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[pCleanDemoAccount]
	(@DemoEmail NVARCHAR(100)
	,@StartDate DATE
	,@EndDate DATE)
AS
	BEGIN
		DECLARE @RC INT = 0
			BEGIN TRY		

                WITH DemoServiceLogs AS (
                    SELECT 
                        LogID
                        ,L.UserID
                        ,IEPKey
                        ,StudentKey
                        ,[Date]
                    FROM dbo.Log AS L
                    INNER JOIN dbo.Users AS U ON U.UserID  = L.UserID 
                    WHERE L.Date >= @StartDate AND L.Date <= @EndDate AND U.UserEmail = @DemoEmail AND LogID > 96459
                )
                DELETE FROM Log WHERE LogID IN (SELECT LogID FROM DemoServiceLogs);

                WITH DemoProgressLogs AS (
                    SELECT 
                        ProgressMonitoringID
                        ,P.UserID
                        ,IEPKey
                        ,StudentKey
                        ,[Date]
                    FROM dbo.ProgressMonitoring AS P
                    INNER JOIN dbo.Users AS U ON U.UserID  = P.UserID 
                    WHERE P.Date >= @StartDate AND P.Date <= @EndDate AND U.UserEmail = @DemoEmail AND ProgressMonitoringID > 3015
                )
                DELETE FROM ProgressMonitoring WHERE ProgressMonitoringID IN (SELECT ProgressMonitoringID FROM DemoProgressLogs)

			SET @RC = +1
			END TRY

			BEGIN CATCH
				PRINT Error_Message()
				SET @RC = -1
			END CATCH

		RETURN @RC;
	END

GO


EXEC pCleanDemoAccount @DemoEmail = 'provider@athlos.org', @StartDate = '2021-02-01', @EndDate = '2021-02-08';
GO

---- GRANT ACCESS TO PARTNER SUCCESS TEAM

GRANT EXECUTE ON dbo.pCleanDemoAccount TO partnersuccess;
GO
