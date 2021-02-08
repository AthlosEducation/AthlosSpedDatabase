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
	('','',3)
	,('','',12)
	,('','',2)
	,('','',2)
	,('','',3)
	,('','',3);
GO

-- Remove from no match list
TRUNCATE TABLE dbo.NoMatchGoalServiceArea;
GO