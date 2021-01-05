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
	('Athlos Academies','Functional Skills',18)
	,('Atwater Elementary School District','Communication    Comunicacion',12)
	,('Atwater Elementary School District','Decoding Words With 3-4 Phonemes',12)
	,('Atwater Elementary School District','Decoding Words With Consonant Blends',12)
	,('Atwater Elementary School District','Numbers & Operations In Base Ten-Add/Subtract',2)
	,('Atwater Elementary School District','Numbers & Operations In Base Ten-Place Value',2)
	,('Atwater Elementary School District','Numbers & Operations-Fractions',2)
	,('Atwater Elementary School District','Ratios And Proportional Relationships',2)
	,('Atwater Elementary School District','Solving Double Digit Addition/Subtraction Problems',2)
	,('Atwater Elementary School District','Task Completion   Completar Tareas',10);
GO

-- Remove from no match list
TRUNCATE TABLE dbo.NoMatchGoalServiceArea;
GO