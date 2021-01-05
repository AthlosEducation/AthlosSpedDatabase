SELECT * FROM Users;
GO

SELECT * FROM AspNetUsers WHERE Id = '8f37fb80-4b68-43c2-b831-5d750dca620a';
GO

UPDATE AspNetUsers
SET UserName = 'nachole.stewart@student.dodea.edu' 
WHERE Id = '8f37fb80-4b68-43c2-b831-5d750dca620a';
GO

UPDATE AspNetUsers
SET Email = 'nachole.stewart@student.dodea.edu' 
WHERE Id = '8f37fb80-4b68-43c2-b831-5d750dca620a';
GO

UPDATE AspNetUsers
SET NormalizedUserName = 'NACHOLE.STEWART.@STUDENT.DODEA.EDU' 
WHERE Id = '8f37fb80-4b68-43c2-b831-5d750dca620a';
GO

UPDATE AspNetUsers
SET NormalizedEmail = 'NACHOLE.STEWART.@STUDENT.DODEA.EDU' 
WHERE Id = '8f37fb80-4b68-43c2-b831-5d750dca620a';
GO