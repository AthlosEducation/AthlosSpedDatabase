BEGIN TRANSACTION;

--------- UDPATE ----------

WITH DuplicateStudentRows AS (
    SELECT 
        StudentID
		,StudentFirstName
        ,StudentLastName
        ,StudentNumber
        ,S.DistrictID
        ,ROW_NUMBER() OVER (
            PARTITION BY 
				StudentID
		        ,StudentFirstName
                ,StudentLastName
                ,StudentNumber
                ,S.DistrictID
            ORDER BY 
				StudentID
		        ,StudentFirstName
                ,StudentLastName
                ,StudentNumber
                ,S.DistrictID
        ) row_num
     FROM 
        dbo.Student AS S 
    GROUP BY
        StudentID
		,StudentFirstName
        ,StudentLastName
        ,StudentNumber
        ,S.DistrictID
), StudentsWithMultipleIDs AS(
                                SELECT TOP 100000000
                                    [StudentID] = MAX(StudentID)
                                    ,StudentFirstName
                                    ,StudentLastName
                                    ,StudentNumber
                                    ,DistrictID
                                    ,[Count] = COUNT(*)
                                FROM DuplicateStudentRows
                                GROUP BY
                                    StudentFirstName
                                    ,StudentLastName
                                    ,StudentNumber
                                    ,DistrictID
                                HAVING COUNT(*) > 1
                                ORDER BY
                                    DistrictID)
                                                UPDATE dbo.IEP 
                                                SET StudentID = CTE.StudentID
                                                FROM StudentsWithMultipleIDs AS CTE
                                                INNER JOIN dbo.Student AS S ON CONCAT(S.StudentFirstName,S.StudentLastName,S.StudentNumber) = CONCAT(CTE.StudentFirstName,CTE.StudentLastName,CTE.StudentNumber)
                                                INNER JOIN dbo.IEP AS IEP ON S.StudentID = IEP.StudentID;
                                                GO

WITH DuplicateStudentRows AS (
    SELECT 
        StudentID
		,StudentFirstName
        ,StudentLastName
        ,StudentNumber
        ,S.DistrictID
        ,ROW_NUMBER() OVER (
            PARTITION BY 
				StudentID
		        ,StudentFirstName
                ,StudentLastName
                ,StudentNumber
                ,S.DistrictID
            ORDER BY 
				StudentID
		        ,StudentFirstName
                ,StudentLastName
                ,StudentNumber
                ,S.DistrictID
        ) row_num
     FROM 
        dbo.Student AS S 
    GROUP BY
        StudentID
		,StudentFirstName
        ,StudentLastName
        ,StudentNumber
        ,S.DistrictID
), StudentsWithMultipleIDs AS(
                                SELECT TOP 100000000
                                    [StudentID] = MAX(StudentID)
                                    ,StudentFirstName
                                    ,StudentLastName
                                    ,StudentNumber
                                    ,DistrictID
                                    ,[Count] = COUNT(*)
                                FROM DuplicateStudentRows
                                GROUP BY
                                    StudentFirstName
                                    ,StudentLastName
                                    ,StudentNumber
                                    ,DistrictID
                                HAVING COUNT(*) > 1
                                ORDER BY
                                    DistrictID)
                                                UPDATE dbo.Student 
                                                SET StudentID = CTE.StudentID
                                                FROM StudentsWithMultipleIDs AS CTE
                                                INNER JOIN dbo.Student AS S ON CONCAT(S.StudentFirstName,S.StudentLastName,S.StudentNumber) = CONCAT(CTE.StudentFirstName,CTE.StudentLastName,CTE.StudentNumber);
                                                GO

COMMIT;

WITH DuplicateGoalRows AS (
    SELECT 
        IEPID
        ,StudentID
		,IEPName
        ,IEPGoal
        ,ROW_NUMBER() OVER (
            PARTITION BY 
                IEPID
                ,StudentID
		        ,IEPName
                ,IEPGoal
            ORDER BY 
                IEPID
                ,StudentID
		        ,IEPName
                ,IEPGoal
        ) row_num
     FROM 
        dbo.IEP AS I
    GROUP BY
        IEPID
        ,StudentID
		,IEPName
        ,IEPGoal
), GoalsWithMultipleIDs AS(
                                SELECT TOP 100000000
                                    [IEPID] = MAX(IEPID)
                                    ,StudentID
                                    ,IEPName
                                    ,IEPGoal
                                    ,[Count] = COUNT(*)
                                FROM DuplicateGoalRows
                                GROUP BY
                                    StudentID
                                    ,IEPName
                                    ,IEPGoal
                                HAVING COUNT(*) > 1
                                ORDER BY
                                    StudentID)
                                                UPDATE dbo.IEP 
                                                SET IEPID = CTE.IEPID
                                                FROM GoalsWithMultipleIDs AS CTE
                                                INNER JOIN dbo.IEP AS I ON CONCAT(I.StudentID,I.IEPGoal) = CONCAT(CTE.StudentID,CTE.IEPGoal);
                                                GO

WITH CTE AS (
    SELECT TOP 100000000
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
                IEPKey DESC
				,StudentID
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
UPDATE dbo.IEP 
SET IEPIsCurrent = 0
WHERE IEPKey IN (SELECT IEPKey FROM CTE WHERE row_num > 1 AND IEPIsCurrent = 1);
GO

WITH CTE AS (
    SELECT TOP 100000000
		StudentKey
		,StudentID
		,StudentFirstName
		,StudentLastName
		,StudentNumber
        ,StudentIsCurrent
        ,ROW_NUMBER() OVER (
            PARTITION BY 
				StudentID
				,StudentFirstName
				,StudentLastName
				,StudentNumber
            ORDER BY 
                StudentKey DESC
				,StudentID
        ) row_num
     FROM 
        dbo.Student
)
UPDATE dbo.Student 
SET StudentIsCurrent = 0
WHERE StudentKey IN (SELECT StudentKey FROM CTE WHERE row_num> 1 AND StudentIsCurrent = 1);
GO