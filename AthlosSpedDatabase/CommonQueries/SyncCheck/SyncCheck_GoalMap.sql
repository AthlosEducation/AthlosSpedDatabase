-- Connect to the staging database
SELECT 
	District
	,GoalCategory
FROM NoMatchGoalServiceArea 
GROUP BY 
	District
	,GoalCategory;
GO

SELECT * FROM GoalServiceAreaMapping;

-- Insert list of new goal names into the Goal Service Area Mapping Table
INSERT INTO dbo.GoalServiceAreaMapping (District, GoalCategory, GoalServiceAreaID)
VALUES 
	('Athlos Academies','Self Control',11)
	,('Atwater Elementary School District','Numbers & Operations In Base Ten  Números Y Operaciones En Base Diez',2)
	,('Atwater Elementary School District','Reading - Decoding/Fluency',3);
GO

-- Remove from no match list
TRUNCATE TABLE dbo.NoMatchGoalServiceArea;
GO