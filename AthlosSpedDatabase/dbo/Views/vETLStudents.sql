
CREATE   VIEW [dbo].[vETLStudents]
/* Author: Christian Macdonald
** Desc: Extracts and transforms student rostering data from staging DB
** Change Log: When,Who,What
** 2020-04-26,Christian Macdonald,Created Sproc.
** 2020-12-02,Christian Macdonald,Added Group by clause.
*/
AS
	SELECT
		[StudentID] = SL.StudentID
		,[StudentFirstName] = CAST(S.givenName AS NVARCHAR(50))
		,[StudentLastName] = CAST(S.familyName AS NVARCHAR(50))
		,[StudentNumber] = CAST(S.identifier AS NVARCHAR(25))
		,[StudentStateID] = CAST(S.metadata AS NVARCHAR(25))
		,[StudentGradeLevel] = TRIM('"]' FROM TRIM('["' FROM S.grades))
		,[DistrictID] = CAST(SC.DistrictID AS INT)
		,[SchoolID] = CAST(SC.SchoolID AS INT)
		,[StudentStartDate] = CAST(GETDATE() AS DATE)
		,[StudentEndDate] = NULL
	FROM vStagingStudents AS S
	INNER JOIN Orgs AS O
	ON O.name = S.orgshref
	INNER JOIN vMatchSchoolID AS SC
	ON SC.name = O.name
	INNER JOIN vStudentIDLinker AS SL
	ON  S.StagDBStudentSelectorID = SL.StagDBStudentSelectorID
	GROUP BY
		SL.StudentID
		,S.givenName
		,S.familyName
		,S.identifier
		,S.metadata
		,S.grades
		,SC.DistrictID
		,SC.SchoolID

GO

