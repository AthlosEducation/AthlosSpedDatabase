SELECT * FROM Users WHERE UserID = 470;
SELECT * FROM AspNetUsers WHERE Id = 'e2674adb-c2d1-4c81-8572-36636857d424';
GO

UPDATE AspNetUsers
SET UserName = 'djohn@northsidechs.org' 
WHERE Id = 'e2674adb-c2d1-4c81-8572-36636857d424';
GO

UPDATE AspNetUsers
SET Email = 'djohn@northsidechs.org' 
WHERE Id = 'e2674adb-c2d1-4c81-8572-36636857d424';
GO

UPDATE AspNetUsers
SET NormalizedUserName = 'DJOHN@NORTHSIDECHS.ORG' 
WHERE Id = 'e2674adb-c2d1-4c81-8572-36636857d424';
GO

UPDATE AspNetUsers
SET NormalizedEmail = 'DJOHN@NORTHSIDECHS.ORG' 
WHERE Id = 'e2674adb-c2d1-4c81-8572-36636857d424';
GO