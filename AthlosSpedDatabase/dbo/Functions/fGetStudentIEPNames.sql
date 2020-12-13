CREATE   -- IEP Name UDF for Check Constraint
FUNCTION dbo.fGetStudentIEPNames (@IEPName NVARCHAR(40),@StudentID INT)
    RETURNS INT
    AS 
        BEGIN
            RETURN (SELECT COUNT(IEPName)
                    FROM dbo.IEP
                    WHERE IEP.IEPName = @IEPName
					AND IEP.StudentID = @StudentID)
        END

GO

