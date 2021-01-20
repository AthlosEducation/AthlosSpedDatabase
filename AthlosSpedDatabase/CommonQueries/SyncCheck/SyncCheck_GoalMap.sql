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
	('Athlos Academies','Aggression/Meltdowns',11)
	,('Athlos Academies','Theater',7)
	,('Atwater Elementary School District','Math Number Sense',2)
	,('Atwater Elementary School District','Oral Comprehension',12)
	,('Atwater Elementary School District','Organization/ Work Completion',10)
	,('Minnesota Internship Center','Organizational Skills',10);
GO

-- Remove from no match list
TRUNCATE TABLE dbo.NoMatchGoalServiceArea;
GO