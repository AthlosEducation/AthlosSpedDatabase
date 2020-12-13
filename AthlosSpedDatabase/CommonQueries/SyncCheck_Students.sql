-- First set the date that needs to be checked
DECLARE @DateToCheck DATE
SET @DateToCheck = CAST(CONVERT(NVARCHAR(50), GETDATE(), 112) AS DATE)
-- Use this query to check which students were updated based on sync and may need to be re-added to caseloads/groups
SELECT * FROM Student WHERE DistrictID = 2 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Athlos Academies
SELECT * FROM Student WHERE DistrictID = 8 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Pullman
SELECT * FROM Student WHERE DistrictID = 9 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Rocky Mountain
SELECT * FROM Student WHERE DistrictID = 10 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Boise School District
SELECT * FROM Student WHERE DistrictID = 11 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Atwater Elementary
SELECT * FROM Student WHERE DistrictID = 12 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Los Altos
SELECT * FROM Student WHERE DistrictID = 13 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Ruidoso
SELECT * FROM Student WHERE DistrictID = 23 AND (StudentEndDate = @DateToCheck OR StudentStartDate = @DateToCheck); -- Buena Vista
GO